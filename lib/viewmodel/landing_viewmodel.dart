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
  void calcblockerSize() async {
    titleBarHeight = await windowManager.getTitleBarHeight();
    Size size = await windowManager.getSize();
    double height = size.height - titleBarHeight - 67;
    _blockerSize = Size(size.width - 16, height);
    calcRect();
    notifyListeners();
  }

  void calcRect() async {
    Rect windowBound = await windowManager.getBounds();
    log(_blockerSize.toString());
    _rectangleModel = RectangleModel(
        height: _blockerSize!.height,
        width: _blockerSize!.width,
        left: windowBound.left + 8,
        top: windowBound.top + titleBarHeight + 59);
  }

  void repeatingCallFrame(bool allowToGet) async {
    prevTimer?.cancel();
    prevTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      imageBytes = null;
      notifyListeners();
      if (allowToGet) {
        blockerCaptureRequest(_rectangleModel!);
        imageBytes = await blockerCaptureFeed();
      } else {
        imageBytes = null;
        timer.cancel();
      }
      notifyListeners();
    });
  }
}
