import 'package:flutter/material.dart';

import '../model/index.dart';


class RectanglePainter extends CustomPainter {
  final List<RectangleModel> rectangles;
  final RectangleModel? currentRect; // Add the currentRect.

  RectanglePainter(this.rectangles, this.currentRect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var rect in rectangles) {
      canvas.drawRect(rect.rect, paint);
    }

    if (currentRect != null) {
      canvas.drawRect(currentRect!.rect, paint); // Draw the currentRect while dragging.
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}