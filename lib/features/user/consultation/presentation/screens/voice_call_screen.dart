import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/consultation/presentation/providers/consultation_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceCallScreen extends ConsumerStatefulWidget {
  final String astrologerId;

  const VoiceCallScreen({
    super.key,
    required this.astrologerId,
  });

  @override
  ConsumerState<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends ConsumerState<VoiceCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _muted = false;
  bool _speakerOn = true;
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
      'voice',
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
    await [Permission.microphone].request();
    
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
    
    // Set audio profile
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
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
  
  void _toggleSpeaker() {
    setState(() {
      _speakerOn = !_speakerOn;
    });
    _engine?.setEnableSpeakerphone(_speakerOn);
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
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
            
            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top info
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: consultationState.currentConsultation?.astrologerProfilePicture != null
                            ? NetworkImage(consultationState.currentConsultation!.astrologerProfilePicture!)
                            : null,
                        child: consultationState.currentConsultation?.astrologerProfilePicture == null
                            ? const Icon(Icons.person, size: 60)
                            : null,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        consultationState.currentConsultation?.astrologerName ?? 'Voice Call',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _remoteUid != null ? 'Connected' : 'Connecting...',
                        style: TextStyle(
                          color: _remoteUid != null ? AppTheme.successColor : Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _formattedDuration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Call controls
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white24,
                        child: IconButton(
                          icon: Icon(
                            _muted ? Icons.mic_off : Icons.mic,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: _toggleMute,
                        ),
                      ),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppTheme.errorColor,
                        child: IconButton(
                          icon: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: _endCall,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white24,
                        child: IconButton(
                          icon: Icon(
                            _speakerOn ? Icons.volume_up : Icons.volume_down,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: _toggleSpeaker,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
