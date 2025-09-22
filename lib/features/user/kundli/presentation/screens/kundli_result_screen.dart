import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/providers/kundli_provider.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/widgets/birth_chart_widget.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/widgets/dasha_table.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/widgets/planet_position_card.dart';
import 'package:intl/intl.dart';

class KundliResultScreen extends ConsumerWidget {
  const KundliResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kundliState = ref.watch(kundliStateProvider);
    
    if (kundliState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (kundliState.kundli == null || kundliState.birthDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Kundli Result'),
        ),
        body: const Center(
          child: Text('No kundli data available'),
        ),
      );
    }
    
    final kundli = kundliState.kundli!;
    final birthDetails = kundliState.birthDetails!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kundli Result'),
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
            // Birth details card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    birthDetails.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Date of Birth',
                    DateFormat('dd MMM yyyy').format(birthDetails.dateOfBirth),
                  ),
                  _buildDetailRow('Time of Birth', birthDetails.timeOfBirth),
                  _buildDetailRow('Place of Birth', birthDetails.placeOfBirth),
                  const Divider(height: 24),
                  _buildDetailRow('Ascendant', kundli.ascendant),
                  _buildDetailRow('Ascendant Lord', kundli.ascendantLord),
                ],
              ),
            ),
            
            // Tabs for different sections
            DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Chart'),
                      Tab(text: 'Planets'),
                      Tab(text: 'Houses'),
                      Tab(text: 'Dasha'),
                    ],
                    labelColor: AppTheme.primaryColor,
                    unselectedLabelColor: AppTheme.secondaryTextColor,
                    indicatorColor: AppTheme.primaryColor,
                  ),
                  SizedBox(
                    height: 500, // Fixed height for tab content
                    child: TabBarView(
                      children: [
                        // Birth Chart Tab
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Birth Chart',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              BirthChartWidget(
                                houseDetails: kundli.houseDetails,
                              ),
                            ],
                          ),
                        ),
                        
                        // Planets Tab
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Planet Positions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: kundli.planetPositions.length,
                                  itemBuilder: (context, index) {
                                    final planet = kundli.planetPositions[index];
                                    return PlanetPositionCard(
                                      planet: planet.planet,
                                      sign: planet.sign,
                                      house: planet.house,
                                      degree: planet.degree,
                                      isRetrograde: planet.isRetrograde,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Houses Tab
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'House Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: kundli.houseDetails.length,
                                  itemBuilder: (context, index) {
                                    final house = kundli.houseDetails[index];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'House ${house.houseNumber}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            _buildDetailRow('Sign', house.sign),
                                            _buildDetailRow('Sign Lord', house.signLord),
                                            if (house.planets.isNotEmpty)
                                              _buildDetailRow(
                                                'Planets',
                                                house.planets.join(', '),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Dasha Tab
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Vimshottari Dasha',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              DashaTable(dashas: kundli.dashas),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Predictions section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'General Predictions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPredictionCard(
                    'Career',
                    kundli.generalPredictions['career'] as String,
                    Icons.work,
                  ),
                  _buildPredictionCard(
                    'Relationships',
                    kundli.generalPredictions['relationships'] as String,
                    Icons.favorite,
                  ),
                  _buildPredictionCard(
                    'Health',
                    kundli.generalPredictions['health'] as String,
                    Icons.health_and_safety,
                  ),
                  _buildPredictionCard(
                    'Finance',
                    kundli.generalPredictions['finance'] as String,
                    Icons.attach_money,
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
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.secondaryTextColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPredictionCard(String title, String content, IconData icon) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
