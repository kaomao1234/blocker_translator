

import 'package:blocker_translator/hooks/index.dart';
import 'package:flutter/material.dart';

class RegionBox extends StatefulWidget {
  late RegionBoxState state;
  void Function(DragUpdateDetails details, RegionBoxState state)
      boxPositionUpdate, boxSizeUpdate;
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
  bool isEnter = false;

  GestureDetector _gestureDetector() {
    return GestureDetector(
        onPanUpdate: (details) => widget.boxPositionUpdate(details, state));
  }

  Column _column() {
    return Column(
      children: [
        Text(
          state.name,
          style: TextStyle(fontSize: 16),
        ),
        TextField(
          decoration: InputDecoration(hintText: "Input box name"),
          controller: state.controller,
          onChanged: (value) {
            setState(() {
              state.name = value;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: state.left,
        top: state.top,
        child: Container(
          width: state.width,
          height: state.height + 20,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (pointerEnter) {
              setState(() {
                isEnter = true;
              });
            },
            onExit: (pointerExit) {
              setState(() {
                isEnter = false;
              });
            },
            child: Column(
              children: [
                Container(
                  height: state.height,
                  width: state.width,
                  decoration: BoxDecoration(
                      color: state.isEdit ? Colors.white : Colors.transparent,
                      border: Border.all(
                          color: isEnter ? Colors.green : Colors.blue,
                          width: 2)),
                  child: state.isEdit ? _column() : _gestureDetector(),
                ),
                if (state.isEdit)
                  SizedBox(
                    height: 20,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        color: Colors.amberAccent,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 18.0,
                              height: 18.0,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onPanUpdate: (details) =>
                                    widget.boxSizeUpdate(details, state),
                                child: Center(
                                  child: Icon(
                                    Icons.crop,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ));
  }
}
