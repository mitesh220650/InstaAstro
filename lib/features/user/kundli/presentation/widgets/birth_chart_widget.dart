import 'package:flutter/material.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/kundli/data/models/kundli_model.dart';

class BirthChartWidget extends StatelessWidget {
  final List<HouseDetail> houseDetails;

  const BirthChartWidget({
    super.key,
    required this.houseDetails,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryColor),
        ),
        child: CustomPaint(
          painter: BirthChartPainter(houseDetails),
        ),
      ),
    );
  }
}

class BirthChartPainter extends CustomPainter {
  final List<HouseDetail> houseDetails;

  BirthChartPainter(this.houseDetails);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Draw outer square
    final outerRect = Rect.fromCenter(
      center: center,
      width: size.width,
      height: size.height,
    );
    
    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    canvas.drawRect(outerRect, paint);
    
    // Draw inner square
    final innerRadius = radius * 0.6;
    final innerRect = Rect.fromCenter(
      center: center,
      width: innerRadius * 2,
      height: innerRadius * 2,
    );
    
    canvas.drawRect(innerRect, paint);
    
    // Draw diagonal lines
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );
    
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
    
    // Draw house numbers and signs
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i < houseDetails.length; i++) {
      final house = houseDetails[i];
      final angle = (i * 30) * (3.14159 / 180); // Convert to radians
      
      // Position for house number
      final houseNumberX = center.dx + (radius * 0.8) * cos(angle);
      final houseNumberY = center.dy + (radius * 0.8) * sin(angle);
      
      // Draw house number
      textPainter.text = TextSpan(
        text: house.houseNumber.toString(),
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(houseNumberX - textPainter.width / 2, houseNumberY - textPainter.height / 2),
      );
      
      // Position for sign
      final signX = center.dx + (radius * 0.4) * cos(angle);
      final signY = center.dy + (radius * 0.4) * sin(angle);
      
      // Draw sign
      textPainter.text = TextSpan(
        text: house.sign.substring(0, 3),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
        ),
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(signX - textPainter.width / 2, signY - textPainter.height / 2),
      );
      
      // Draw planets if any
      if (house.planets.isNotEmpty) {
        final planetsText = house.planets.map((p) => p.substring(0, 2)).join(',');
        final planetsX = center.dx + (radius * 0.2) * cos(angle);
        final planetsY = center.dy + (radius * 0.2) * sin(angle);
        
        textPainter.text = TextSpan(
          text: planetsText,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        );
        
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(planetsX - textPainter.width / 2, planetsY - textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
