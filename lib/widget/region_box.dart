import 'package:blocker_translator/hooks/region_box.dart';
import 'package:flutter/material.dart';

class RegionBox extends StatefulWidget {
  late RegionBoxState state;
  void Function(DragUpdateDetails details) boxPositionUpdate, boxSizeUpdate;
  RegionBox(
      {super.key,
      required this.state,
      required this.boxPositionUpdate,
      required this.boxSizeUpdate});

  @override
  State<RegionBox> createState() => _RegionBoxState();
}

class _RegionBoxState extends State<RegionBox> {
  late RegionBoxState state = widget.state;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: state.left,
        top: state.top,
        child: Container(
          width: state.width,
          height: state.height,
          color: Colors.blue,
          child: Column(
            children: [
              Expanded(
                  child:
                      GestureDetector(onPanUpdate: widget.boxPositionUpdate)),
              SizedBox(
                height: 18,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onPanUpdate: widget.boxSizeUpdate,
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
