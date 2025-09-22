import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/kundli/data/models/kundli_model.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/providers/kundli_provider.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/screens/kundli_form_screen.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/screens/kundli_result_screen.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/widgets/profile_card.dart';
import 'package:intl/intl.dart';

class KundliScreen extends ConsumerWidget {
  const KundliScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedProfilesAsync = ref.watch(savedProfilesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kundli'),
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
                      'Free Kundli Analysis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),<boltAction type="file" filePath="lib/features/user/kundli/presentation/screens/kundli_screen.dart">
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Get detailed insights about your birth chart, planets, houses, and predictions',
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
                            builder: (context) => const KundliFormScreen(),
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
                      child: const Text('Generate New Kundli'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Saved profiles
              const Text(
                'Saved Profiles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              savedProfilesAsync.when(
                data: (profiles) {
                  if (profiles.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'No saved profiles yet',
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
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profiles[index];
                      return ProfileCard(
                        name: profile.name,
                        dateOfBirth: DateFormat('dd MMM yyyy').format(profile.dateOfBirth),
                        timeOfBirth: profile.timeOfBirth,
                        placeOfBirth: profile.placeOfBirth,
                        onTap: () {
                          ref.read(kundliStateProvider.notifier).generateKundli(profile);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KundliResultScreen(),
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
                icon: Icons.auto_graph,
                title: 'Birth Chart Analysis',
                description: 'Detailed analysis of your birth chart with planetary positions',
              ),
              
              _buildFeatureCard(
                icon: Icons.calendar_today,
                title: 'Dasha Predictions',
                description: 'Know your current and future planetary periods',
              ),
              
              _buildFeatureCard(
                icon: Icons.home,
                title: 'House Analysis',
                description: 'Understand the influence of planets in different houses',
              ),
              
              _buildFeatureCard(
                icon: Icons.star,
                title: 'Personalized Predictions',
                description: 'Get personalized predictions based on your birth chart',
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
