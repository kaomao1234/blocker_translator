import 'dart:developer';

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
  final List<Rect> rectangles = [];
  Rect? currentRect;
  Rect? tempRect;
  final blockerSizeNotifier = ValueNotifier<Size>(Size.zero);

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

  void addRect(Offset start, Offset end) {
    setState(() {
      rectangles.add(Rect.fromPoints(start, end));
    });
  }

  Widget drawableRectangle(Size blockerSize) {
    return SizedBox(
      width: blockerSize.width > 0 ? blockerSize.width : null,
      height: blockerSize.height > 0 ? blockerSize.height : null,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onPanStart: (details) {
                currentRect = Rect.fromPoints(
                    details.localPosition, details.localPosition);
              },
              onPanUpdate: (details) {
                setState(() {
                  Offset end = details.localPosition;
                  Offset start = currentRect!.topLeft;
                  if (start.dy < 0) {
                    start = Offset(start.dx, 5);
                  }
                  if (start.dx < 0) {
                    start = Offset(5, start.dy);
                  }

                  if (end.dx > blockerSize.width) {
                    end = Offset(blockerSize.width, details.localPosition.dy);
                  }
                  if (end.dy > blockerSize.height) {
                    end = Offset(end.dx, blockerSize.height);
                  }
                  currentRect = Rect.fromPoints(start, end);
                });
              },
              onPanEnd: (details) {
                addRect(currentRect!.topLeft, currentRect!.bottomRight);
              },
              child: CustomPaint(
                painter: RectanglePainter(rectangles, currentRect),
              ),
            ),
          ),
        ],
      ),
    );
  }

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