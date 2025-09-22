import 'package:flutter/material.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';

class PlanetPositionCard extends StatelessWidget {
  final String planet;
  final String sign;
  final String house;
  final double degree;
  final bool isRetrograde;

  const PlanetPositionCard({
    super.key,
    required this.planet,
    required this.sign,
    required this.house,
    required this.degree,
    required this.isRetrograde,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getPlanetSymbol(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planet,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sign: $sign',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  'House: $house',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Degree: ${degree.toStringAsFixed(2)}°',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (isRetrograde)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Retrograde',
                style: TextStyle(
                  color: AppTheme.warningColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  String _getPlanetSymbol() {
    switch (planet.toLowerCase()) {
      case 'sun':
        return '☉';
      case 'moon':
        return '☽';
      case 'mercury':
        return '☿';
      case 'venus':
        return '♀';
      case 'mars':
        return '♂';
      case 'jupiter':
        return '♃';
      case 'saturn':
        return '♄';
      case 'rahu':
        return '☊';
      case 'ketu':
        return '☋';
      default:
        return planet[0];
    }
  }
}
