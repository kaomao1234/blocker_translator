import 'dart:developer';

import 'package:blocker_translator/model/rectangle.dart';
import 'package:blocker_translator/viewmodel/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../widget/index.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> with WindowListener {
  bool isPlay = false;
  GlobalKey key = GlobalKey();
  bool isSwicthMode = false;
  List<RectangleModel> rectangles = [];
  RectangleModel? currentRect;
  Rect? tempRect;
  final blockerSizeNotifier = ValueNotifier<Size>(Size.zero);

  double top = 100.0;
  double left = 100.0;
  double width = 200.0;
  double height = 100.0;

  LandingViewModel get viewModel =>
      Provider.of<LandingViewModel>(context, listen: false);

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void onPlayPress() {
    setState(() {
      isPlay = !isPlay;
      viewModel.repeatingCallFrame(isPlay);
    });
  }

  Size getRedBoxSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  @override
  void onWindowEvent(String eventName) {
    viewModel.calcblockerSize();
    super.onWindowEvent(eventName);
  }

  Widget drawableRectangle(Size size) {
    return SizedBox(
      width: size.width > 0 ? size.width : null,
      height: size.height > 0 ? size.height : null,
      child: Stack(
        children: [
          RegionBox(
            height,
            left,
            top,
            width,
            boxPostionUpdate: (details) {
              setState(() {
                left += details.delta.dx;
                top += details.delta.dy;
              });
            },
            boxSizeUpdate: (details) {
              setState(() {
                width += details.delta.dx;
                height += details.delta.dy;
              });
            },
          ),
        ],
      ),
    );
  }

  // Widget drawableRectangle(Size blockerSize) {
  //   return SizedBox(
  //     width: blockerSize.width > 0 ? blockerSize.width : null,
  //     height: blockerSize.height > 0 ? blockerSize.height : null,
  //     child: Stack(
  //       children: [
  //         Positioned.fill(
  //           child: GestureDetector(
  //             onPanStart: (details) {
  //               currentRect = RectangleModel(
  //                   Rect.fromPoints(
  //                       details.localPosition, details.localPosition),
  //                   "");
  //             },
  //             onPanUpdate: (details) {
  //               setState(() {
  //                 Offset end = details.localPosition;
  //                 Offset start = currentRect!.rect.topLeft;
  //                 if (start.dy < 0) {
  //                   start = Offset(start.dx, 5);
  //                 }
  //                 if (start.dx < 0) {
  //                   start = Offset(3, start.dy);
  //                 }

  //                 if (end.dx > blockerSize.width) {
  //                   end = Offset(blockerSize.width, details.localPosition.dy);
  //                 }
  //                 if (end.dy > blockerSize.height) {
  //                   end = Offset(end.dx, blockerSize.height);
  //                 }
  //                 currentRect!.rect = Rect.fromPoints(start, end);
  //               });
  //             },
  //             onPanEnd: (details) {
  //               setState(() {
  //                 rectangles.add(currentRect!);
  //               });
  //             },
  //             child: CustomPaint(
  //               painter: RectanglePainter(rectangles, currentRect),
  //             ),
  //           ),
  //         ),
  //         for (var i in rectangles)
  //           Positioned(
  //             top: i.rect.top - 50,
  //             right: i.rect.right,
  //             height: 50,
  //             width: 100,
  //             child: Checkbox(
  //               onChanged: (bool? val) {
  //                 setState(() {
  //                   i.isEditing = val!;
  //                 });
  //               },
  //               value: i.isEditing,
  //             ),
  //           )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<LandingViewModel>(
      builder: (context, value, child) {
        return core(context, value);
      },
    );
  }

  Widget core(BuildContext context, LandingViewModel viewModel) {
    blockerSizeNotifier.value = viewModel.getblockerSize!;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Row(children: [
            IconButton(
                splashRadius: 25,
                iconSize: 30,
                onPressed: onPlayPress,
                icon: isPlay
                    ? const Icon(
                        Icons.pause,
                        color: Colors.grey,
                        size: 25,
                      )
                    : const Icon(
                        Icons.play_arrow,
                        color: Colors.red,
                        size: 25,
                      )),
            Text(
              viewModel.getblockerSize.toString(),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(
              width: 10,
            ),
            TextButton(
              child: Text(
                !isSwicthMode ? "blocker mode" : "rectangle mode",
                style: TextStyle(
                    fontSize: 16,
                    color: !isSwicthMode ? Colors.black : Colors.blue),
              ),
              onPressed: () {
                setState(() {
                  isSwicthMode = !isSwicthMode;
                  // viewModel.prevTimer!.cancel();
                });
              },
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    rectangles.clear();
                    currentRect = null;
                  });
                },
                child: Text(
                  "clear",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ))
          ]),
        ),
        backgroundColor: Colors.transparent,
        body: isSwicthMode
            ? ValueListenableBuilder(
                valueListenable: blockerSizeNotifier,
                builder: (context, value, child) {
                  return drawableRectangle(value);
                },
              )
            : Container());
  }
}
