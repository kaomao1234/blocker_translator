
import 'package:flutter/material.dart';

class ResizableBox extends StatefulWidget {
  @override
  _ResizableBoxState createState() => _ResizableBoxState();
}

class _ResizableBoxState extends State<ResizableBox> {
  static const handleSize = 20.0;
  static const handleOffset = 10.0;
  static const minWidthHeight = 50.0;

  double left = 100.0;
  double top = 100.0;
  double right = 300.0;
  double bottom = 300.0;

  double get width => right - left;
  double get height => bottom - top;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resizable Box'),
      ),
      body: Center(
        child: Stack(
          children: [
            for (final direction in ResizeDirection.values)
              Positioned(
                left: _getHandleLeft(direction) - handleOffset,
                top: _getHandleTop(direction) - handleOffset,
                child: _buildResizeHandle(direction),
              ),
            Positioned(
              left: left,
              top: top,
              width: width,
              height: height,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getHandleLeft(ResizeDirection direction) {
    return direction == ResizeDirection.topLeft || direction == ResizeDirection.bottomLeft
        ? left
        : right;
  }

  double _getHandleTop(ResizeDirection direction) {
    return direction == ResizeDirection.topLeft || direction == ResizeDirection.topRight
        ? top
        : bottom;
  }

  Widget _buildResizeHandle(ResizeDirection direction) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          if (direction == ResizeDirection.topLeft) {
            left += details.delta.dx;
            top += details.delta.dy;
          } else if (direction == ResizeDirection.topRight) {
            right += details.delta.dx;
            top += details.delta.dy;
          } else if (direction == ResizeDirection.bottomLeft) {
            left += details.delta.dx;
            bottom += details.delta.dy;
          } else if (direction == ResizeDirection.bottomRight) {
            right += details.delta.dx;
            bottom += details.delta.dy;
          }

          if (right - left < minWidthHeight) {
            if (direction == ResizeDirection.topLeft || direction == ResizeDirection.bottomLeft) {
              left = right - minWidthHeight;
            } else {
              right = left + minWidthHeight;
            }
          }

          if (bottom - top < minWidthHeight) {
            if (direction == ResizeDirection.topLeft || direction == ResizeDirection.topRight) {
              top = bottom - minWidthHeight;
            } else {
              bottom = top + minWidthHeight;
            }
          }
        });
      },
      child: Container(
        width: handleSize,
        height: handleSize,
        color: Colors.red,
      ),
    );
  }
}

enum ResizeDirection { topLeft, topRight, bottomLeft, bottomRight }
