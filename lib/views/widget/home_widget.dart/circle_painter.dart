import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  CirclePainter({this.colors, required this.paintingStyle});
  final PaintingStyle paintingStyle;
  final List<Color>? colors;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader =
          LinearGradient(colors: colors ?? <Color>[])
              .createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ))
      ..style = paintingStyle // Use stroke to draw only the border
      ..strokeWidth = 20.0; // Set the width of the border

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    canvas.drawCircle(Offset(centerX, centerY), radius, paint,);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
