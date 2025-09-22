import 'package:flutter/material.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';

class MatchCategoryCard extends StatelessWidget {
  final String name;
  final int score;
  final int maxScore;
  final String description;

  const MatchCategoryCard({
    super.key,
    required this.name,
    required this.score,
    required this.maxScore,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / maxScore) * 100;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '$score/$maxScore',
              style: TextStyle(
                color: _getColorForPercentage(percentage),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: LinearProgressIndicator(
          value: score / maxScore,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(_getColorForPercentage(percentage)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getColorForPercentage(double percentage) {
    if (percentage < 25) {
      return Colors.red;
    } else if (percentage < 50) {
      return Colors.orange;
    } else if (percentage < 75) {
      return AppTheme.warningColor;
    } else {
      return AppTheme.successColor;
    }
  }
}
