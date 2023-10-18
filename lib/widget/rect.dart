import 'package:flutter/material.dart';

import '../model/index.dart';


class RectanglePainter extends CustomPainter {
  final List<Rect> rectangles;
  final Rect? currentRect; // Add the currentRect.

  RectanglePainter(this.rectangles, this.currentRect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var rect in rectangles) {
      canvas.drawRect(rect, paint);
    }

    if (currentRect != null) {
      canvas.drawRect(currentRect!, paint); // Draw the currentRect while dragging.
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}