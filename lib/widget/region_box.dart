import 'dart:developer';

import 'package:blocker_translator/hooks/index.dart';
import 'package:flutter/material.dart';

class RegionBox extends StatefulWidget {
  late RegionBoxState state;
  void Function(VoidCallback fn) hook;
  Size areaSize;
  RegionBox({
    super.key,
    required this.state,
    required this.hook,
    required this.areaSize,
  });

  @override
  State<RegionBox> createState() => _RegionBoxState();
}

class _RegionBoxState extends State<RegionBox> {
  late RegionBoxState state = widget.state;
  bool isEnter = false;
  GestureDetector _gestureDetector() {
    return GestureDetector(
        onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text(state.name),
                  content: TextField(
                    onChanged: (value) {
                      setState(() {
                        state.name = value!;
                      });
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                )),
        onPanUpdate: (details) {
          widget.hook(() {
            double top = details.delta.dy, left = details.delta.dx;
            state.top += top;
            state.left += left;
            double bottom = state.top + state.height;
            double right = state.left + state.width;
            double maxTop = widget.areaSize.height - state.height;
            double maxLeft = widget.areaSize.width - state.width;
            state.top = state.top < 0 ? 0 : state.top;
            state.left = state.left < 0 ? 0 : state.left;
            state.top = bottom > widget.areaSize.height ? maxTop : state.top;
            state.left = right > widget.areaSize.width ? maxLeft : state.left;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: state.left,
        top: state.top,
        child: SizedBox(
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
                      color: Colors.transparent,
                      border: Border.all(
                          color: isEnter ? Colors.green : Colors.blue,
                          width: 2)),
                  child: _gestureDetector(),
                ),
                SizedBox(
                  height: 20,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.name,
                          ),
                          Container(
                            width: 18.0,
                            height: 18.0,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                widget.hook(
                                  () {
                                    state.width += details.delta.dx;
                                    state.height += details.delta.dy;
                                    state.width =
                                        state.width <= 0 ? 100 : state.width;
                                    state.height =
                                        state.height <= 0 ? 100 : state.height;
                                  },
                                );
                              },
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
