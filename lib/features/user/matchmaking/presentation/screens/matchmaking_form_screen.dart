import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/matchmaking/data/models/matchmaking_model.dart';
import 'package:instaastro_clone/features/user/matchmaking/presentation/providers/matchmaking_provider.dart';
import 'package:instaastro_clone/features/user/matchmaking/presentation/screens/matchmaking_result_screen.dart';
import 'package:intl/intl.dart';

class MatchmakingFormScreen extends ConsumerStatefulWidget {
  const MatchmakingFormScreen({super.key});

  @override
  ConsumerState<MatchmakingFormScreen> createState() => _MatchmakingFormScreenState();
}

class _MatchmakingFormScreenState extends ConsumerState<MatchmakingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Boy details
  final _boyNameController = TextEditingController();
  final _boyDobController = TextEditingController();
  final _boyTobController = TextEditingController();
  final _boyPobController = TextEditingController();
  
  // Girl details
  final _girlNameController = TextEditingController();
  final _girlDobController = TextEditingController();
  final _girlTobController = TextEditingController();
  final _girlPobController = TextEditingController();
  
  DateTime? _boySelectedDate;
  TimeOfDay? _boySelectedTime;
  DateTime? _girlSelectedDate;
  TimeOfDay? _girlSelectedTime;
  
  bool _saveMatch = true;
  bool _isLoading = false;
  
  @override
  void dispose() {
    _boyNameController.dispose();
    _boyDobController.dispose();
    _boyTobController.dispose();
    _boyPobController.dispose();
    _girlNameController.dispose();
    _girlDobController.dispose();
    _girlTobController.dispose();
    _girlPobController.dispose();
    super.dispose();
  }
  
  Future<void> _selectBoyDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _boySelectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _boySelectedDate) {
      setState(() {
        _boySelectedDate = picked;
        _boyDobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
  
  Future<void> _selectBoyTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _boySelectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _boySelectedTime) {
      setState(() {
        _boySelectedTime = picked;
        _boyTobController.text = picked.format(context);
      });
    }
  }
  
  Future<void> _selectGirlDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _girlSelectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _girlSelectedDate) {
      setState(() {
        _girlSelectedDate = picked;
        _girlDobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
  
  Future<void> _selectGirlTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _girlSelectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _girlSelectedTime) {
      setState(() {
        _girlSelectedTime = picked;
        _girlTobController.text = picked.format(context);
      });
    }
  }
  
  Future<void> _checkCompatibility() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Create matchmaking request
      final request = MatchmakingRequest(
        boyName: _boyNameController.text,
        boyDob: _boySelectedDate!,
        boyTob: _boyTobController.text,
        boyPob: _boyPobController.text,
        girlName: _girlNameController.text,
        girlDob: _girlSelectedDate!,
        girlTob: _girlTobController.text,
        girlPob: _girlPobController.text,
      );
      
      try {
        // Get matchmaking result
        await ref.read(matchmakingStateProvider.notifier).getMatchmaking(request);
        
        // Save match if checkbox is checked
        if (_saveMatch) {
          await ref.read(matchmakingStateProvider.notifier).saveMatch(request);
        }
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MatchmakingResultScreen(),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kundli Matching'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Boy details section
                const Text(
                  'Boy Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _boyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter boy\'s name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _boyDobController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectBoyDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select date of birth';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _boyTobController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Time of Birth',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  onTap: () => _selectBoyTime(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select time of birth';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _boyPobController,
                  decoration: const InputDecoration(
                    labelText: 'Place of Birth',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter place of birth';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Girl details section
                const Text(
                  'Girl Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _girlNameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter girl\'s name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _girlDobController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectGirlDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select date of birth';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _girlTobController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Time of Birth',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  onTap: () => _selectGirlTime(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select time of birth';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _girlPobController,
                  decoration: const InputDecoration(
                    labelText: 'Place of Birth',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter place of birth';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Save match checkbox
                CheckboxListTile(
                  value: _saveMatch,
                  onChanged: (value) {
                    setState(() {
                      _saveMatch = value ?? true;
                    });
                  },
                  title: const Text('Save this match for future reference'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 32),
                
                // Check compatibility button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _checkCompatibility,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Check Compatibility'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

<boltAction type="file" filePath="lib/features/user/matchmaking/presentation/screens/matchmaking_result_screen.dart">
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/matchmaking/presentation/providers/matchmaking_provider.dart';
import 'package:instaastro_clone/features/user/matchmaking/presentation/widgets/compatibility_meter.dart';
import 'package:instaastro_clone/features/user/matchmaking/presentation/widgets/match_category_card.dart';
import 'package:intl/intl.dart';

class MatchmakingResultScreen extends ConsumerWidget {
  const MatchmakingResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchmakingState = ref.watch(matchmakingStateProvider);
    
    if (matchmakingState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (matchmakingState.matchResult == null || matchmakingState.request == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Compatibility Result'),
        ),
        body: const Center(
          child: Text('No matchmaking data available'),
        ),
      );
    }
    
    final result = matchmakingState.matchResult!;
    final request = matchmakingState.request!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compatibility Result'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Download functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Names and score
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    Color(0xFF5C6BC0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Text(
                              request.boyName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            request.boyName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy').format(request.boyDob),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          '${result.totalScore}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Text(
                              request.girlName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            request.girlName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy').format(request.girlDob),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CompatibilityMeter(score: result.totalScore),
                ],
              ),
            ),
            
            // Conclusion
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Conclusion',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      result.conclusion,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Categories
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ashtakoot Analysis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...result.categories.entries.map((entry) {
                    return MatchCategoryCard(
                      name: entry.value.name,
                      score: entry.value.score,
                      maxScore: entry.value.maxScore,
                      description: entry.value.description,
                    );
                  }).toList(),
                ],
              ),
            ),
            
            // Recommendations
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommendations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: result.recommendations.map((recommendation) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.successColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  recommendation,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            
            // Consult astrologer button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/astrologers');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Consult an Astrologer for Detailed Analysis'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
