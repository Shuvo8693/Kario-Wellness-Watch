

// Custom Painter for Hexagon
import 'package:flutter/material.dart';

class HexagonPainter extends CustomPainter  {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    for (int i = 0; i < 6; i++) {
      final angle = (60 * i - 30) * 3.14159 / 180;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  double cos(double angle) =>
      (angle == 0) ? 1.0 :
      (angle == 1.0472) ? 0.5 :
      (angle == 2.0944) ? -0.5 :
      (angle == 3.14159) ? -1.0 :
      (angle == -2.0944) ? -0.5 :
      (angle == -1.0472) ? 0.5 : 0.866;

  double sin(double angle) =>
      (angle == 0) ? 0.0 :
      (angle == 1.0472) ? 0.866 :
      (angle == 2.0944) ? 0.866 :
      (angle == 3.14159) ? 0.0 :
      (angle == -2.0944) ? -0.866 :
      (angle == -1.0472) ? -0.866 : 0.5;
}