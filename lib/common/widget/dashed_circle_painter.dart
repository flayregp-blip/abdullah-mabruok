import 'dart:math' as math;

import 'package:flutter/material.dart';

class DashedCirclePainter extends CustomPainter {
  final double progress;

  DashedCirclePainter(this.progress) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    const int dashCount = 50; // More dashes, smaller gaps
    const double dashWidth = 3;
    const double dashHeight = 4;
    final int progressDashes = (dashCount * progress).toInt();

    final Paint basePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = dashWidth
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = dashWidth
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < dashCount; i++) {
      double startAngle = (-math.pi / 2) +
          (i * 2 * math.pi) / dashCount; // Starts at 12 o'clock
      final bool isProgress = i < progressDashes;
      canvas.drawLine(
        Offset(
          radius + (radius - dashHeight / 2) * math.cos(startAngle),
          radius + (radius - dashHeight / 2) * math.sin(startAngle),
        ),
        Offset(
          radius + (radius - dashHeight - 2) * math.cos(startAngle),
          radius + (radius - dashHeight - 2) * math.sin(startAngle),
        ),
        isProgress ? progressPaint : basePaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
