import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/consultation/presentation/providers/consultation_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  final String astrologerId;

  const VideoCallScreen({
    super.key,
    required this.astrologerId,
  });

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _muted = false;
  bool _cameraOff = false;
  bool _frontCamera = true;
  RtcEngine? _engine;
  Timer? _timer;
  int _elapsedSeconds = 0;
  
  @override
  void initState() {
    super.initState();
    _initConsultation();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _disposeAgoraEngine();
    super.dispose();
  }
  
  Future<void> _initConsultation() async {
    await ref.read(consultationProvider.notifier).startConsultation(
      widget.astrologerId,
      'video',
    );
    
    final consultationState = ref.read(consultationProvider);
    if (consultationState.currentConsultation != null) {
      await _initAgoraEngine();
      _startTimer();
    }
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }
  
  String get _formattedDuration {
    final duration = Duration(seconds: _elapsedSeconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  
  Future<void> _initAgoraEngine() async {
    // Request permissions
    await [Permission.microphone, Permission.camera].request();
    
    // Create RTC engine instance
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: 'YOUR_AGORA_APP_ID', // Replace with your Agora App ID
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    
    // Register event handlers
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
    
    // Set video and audio profile
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableVideo();
    await _engine!.enableAudio();
    
    // Get token from server
    final consultationState = ref.read(consultationProvider);
    final channelName = 'call_${consultationState.currentConsultation!.id}';
    final uid = 1000; // Use a unique ID for the user
    
    try {
      final token = await ref.read(consultationProvider.notifier).generateAgoraToken(
        channelName,
        uid.toString(),
      );
      
      // Join channel
      await _engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error joining call: ${e.toString()}')),
      );
    }
  }
  
  void _disposeAgoraEngine() {
    _engine?.leaveChannel();
    _engine?.release();
  }
  
  void _toggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine?.muteLocalAudioStream(_muted);
  }
  
  void _toggleCamera() {
    setState(() {
      _cameraOff = !_cameraOff;
    });
    _engine?.enableLocalVideo(!_cameraOff);
  }
  
  void _switchCamera() {
    _engine?.switchCamera();
    setState(() {
      _frontCamera = !_frontCamera;
    });
  }
  
  void _endCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Call'),
        content: const Text('Are you sure you want to end this call?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _disposeAgoraEngine();
              ref.read(consultationProvider.notifier).endConsultation();
              Navigator.pop(context); // Go back to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('End'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final consultationState = ref.watch(consultationProvider);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote video
          _remoteUid != null
              ? AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: _engine!,
                    canvas: VideoCanvas(uid: _remoteUid),
                    connection: const RtcConnection(channelId: 'call'),
                  ),
                )
              : const Center(
                  child: Text(
                    'Waiting for astrologer to join...',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
          
          // Local video (small picture-in-picture)
          if (_localUserJoined && !_cameraOff)
            Positioned(
              right: 16,
              top: 50,
              child: Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine!,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ),
            ),
          
          // Call info overlay
          Positioned(
            top: 40,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consultationState.currentConsultation?.astrologerName ?? 'Video Call',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formattedDuration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Call controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    icon: Icon(
                      _muted ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: _toggleMute,
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    icon: Icon(
                      _cameraOff ? Icons.videocam_off : Icons.videocam,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: _toggleCamera,
                  ),
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppTheme.errorColor,
                  child: IconButton(
                    icon: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _endCall,
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    icon: const Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: _switchCamera,
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      // Show more options
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
