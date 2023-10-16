import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:blocker_translator/api/index.dart';
import 'package:blocker_translator/model/index.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class LandingViewModel with ChangeNotifier {
  Size? _blockerSize;
  RectangleModel? _rectangleModel;
  Size? get getblockerSize => _blockerSize;
  Uint8List? imageBytes;
  int titleBarHeight = 0;
  Timer? prevTimer;
  int frameCounter = 0;
  int lastTime = DateTime.now().millisecondsSinceEpoch;
  int fps = 0;
  void calcblockerSize() async {
    titleBarHeight = await windowManager.getTitleBarHeight();
    Size size = await windowManager.getSize();
    double height = size.height - titleBarHeight - 67;
    _blockerSize = Size(size.width - 16, height);
    calcRect();
    notifyListeners();
  }

  RectangleModel? get rectangleModel => _rectangleModel;

  void calcRect() async {
    Rect windowBound = await windowManager.getBounds();
    _rectangleModel = RectangleModel(
        height: _blockerSize!.height,
        width: _blockerSize!.width,
        left: windowBound.left + 8,
        top: windowBound.top + titleBarHeight + 59);
  }

  void repeatingCallFrame(
      bool allowToGet, void Function(Uint8List? imageBytes) callback) async {
    prevTimer?.cancel();
    prevTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      imageBytes = null;
      callback(imageBytes);
      if (allowToGet) {
        blockerCaptureRequest(_rectangleModel!);
        imageBytes = await blockerCaptureFeed();
        String? textCaptured = await textFromImage();
        log(textCaptured.toString());
      } else {
        imageBytes = null;
        timer.cancel();
      }
      callback(imageBytes);
    });
  }

  Future<String> callTextFromImage() async {
    return await textFromImage() ?? "";
  }

  Future<Uint8List> callBlockerCaptureFeed() async {
    blockerCaptureRequest(_rectangleModel!);
    return await blockerCaptureFeed() ?? Uint8List(0);
  }

  Future<Uint8List> callFrame() async {
    return await frame() ?? Uint8List(0);
  }

  bool timeDifferenceBiggerThanSecond() {
    return DateTime.now().millisecondsSinceEpoch - lastTime > 1000;
  }
}
