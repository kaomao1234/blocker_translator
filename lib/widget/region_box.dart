import 'package:flutter/material.dart';

class RegionBox extends StatelessWidget {
  late void Function(DragUpdateDetails) boxPostionUpdate, boxSizeUpdate;
  late double top, left, width, height;
  RegionBox(this.height, this.left, this.top, this.width,
      {super.key, required this.boxPostionUpdate, required this.boxSizeUpdate});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: left,
        top: top,
        child: Container(
          width: width,
          height: height,
          color: Colors.blue,
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                onPanUpdate: boxPostionUpdate,
              )),
              SizedBox(
                height: 18,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onPanUpdate: boxSizeUpdate,
                    child: Container(
                      width: 18.0,
                      height: 18.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.crop,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
