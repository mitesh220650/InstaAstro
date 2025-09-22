import 'package:flutter/material.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';

class CompatibilityMeter extends StatelessWidget {
  final int score;

  const CompatibilityMeter({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(_getColorForScore(score)),
                ),
              ),
            ),
            Text(
              _getCompatibilityText(score),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Poor',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            Text(
              'Average',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            Text(
              'Good',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            Text(
              'Excellent',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Color _getColorForScore(int score) {
    if (score < 25) {
      return Colors.red;
    } else if (score < 50) {
      return Colors.orange;
    } else if (score < 75) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
  
  String _getCompatibilityText(int score) {
    if (score < 25) {
      return 'Poor Match';
    } else if (score < 50) {
      return 'Average Match';
    } else if (score < 75) {
      return 'Good Match';
    } else {
      return 'Excellent Match';
    }
  }
}
