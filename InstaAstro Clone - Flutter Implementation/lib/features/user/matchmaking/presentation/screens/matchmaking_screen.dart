import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/matchmaking/data/models/matchmaking_model.dart';
import 'package:instaastro_clone/features/user/matchmaking/presentation/providers/matchmaking_provider.dart';
import 'package:instaastro_clone/features/user/matchmaking/presentation/screens/matchmaking_form_screen.dart';
import 'package:instaastro_clone/features/user/matchmaking/presentation/screens/matchmaking_result_screen.dart';
import 'package:instaastro_clone/features/user/matchmaking/presentation/widgets/match_card.dart';
import 'package:intl/intl.dart';

class MatchmakingScreen extends ConsumerWidget {
  const MatchmakingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedMatchesAsync = ref.watch(savedMatchesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matchmaking'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      Color(0xFF5C6BC0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kundli Matching',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Check compatibility between two birth charts based on Ashtakoot method',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MatchmakingFormScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                      child: const Text('Check Compatibility'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Saved matches
              const Text(
                'Saved Matches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              savedMatchesAsync.when(
                data: (matches) {
                  if (matches.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'No saved matches yet',
                          style: TextStyle(
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      final match = matches[index];
                      return MatchCard(
                        boyName: match.boyName,
                        girlName: match.girlName,
                        boyDob: DateFormat('dd MMM yyyy').format(match.boyDob),
                        girlDob: DateFormat('dd MMM yyyy').format(match.girlDob),
                        onTap: () {
                          ref.read(matchmakingStateProvider.notifier).getMatchmaking(match);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MatchmakingResultScreen(),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text('Error: ${error.toString()}'),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Features
              const Text(
                'Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildFeatureCard(
                icon: Icons.favorite,
                title: 'Ashtakoot Matching',
                description: 'Traditional Vedic method to check compatibility between two individuals',
              ),
              
              _buildFeatureCard(
                icon: Icons.people,
                title: 'Detailed Analysis',
                description: 'Get scores for various aspects like temperament, mental compatibility, etc.',
              ),
              
              _buildFeatureCard(
                icon: Icons.lightbulb,
                title: 'Recommendations',
                description: 'Personalized suggestions to improve compatibility',
              ),
              
              _buildFeatureCard(
                icon: Icons.save,
                title: 'Save Matches',
                description: 'Save your matches for future reference',
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 14,
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
