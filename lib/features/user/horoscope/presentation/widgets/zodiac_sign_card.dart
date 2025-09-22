import 'package:flutter/material.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/horoscope/data/models/horoscope_model.dart';

class ZodiacSignCard extends StatelessWidget {
  final ZodiacSign sign;
  final bool isSelected;
  final VoidCallback onTap;

  const ZodiacSignCard({
    super.key,
    required this.sign,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              sign.icon,
              width: 32,
              height: 32,
              color: isSelected ? Colors.white : null,
            ),
            const SizedBox(height: 8),
            Text(
              sign.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
