import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:blocker_translator/api/index.dart';
import 'package:blocker_translator/model/index.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../hooks/region_box.dart';

class LandingViewModel with ChangeNotifier {
  Size? _blockerSize;
  BlockerModel? _blockerModel;
  Size? get getblockerSize => _blockerSize;
  Uint8List? imageBytes;
  int titleBarHeight = 0;
  Timer? prevTimer;
  int frameCounter = 0;
  int lastTime = DateTime.now().millisecondsSinceEpoch;
  String prevText = "";
  void calcblockerSize() async {
    titleBarHeight = await windowManager.getTitleBarHeight();
    Size size = await windowManager.getSize();
    double height = size.height - titleBarHeight - 67;
    _blockerSize = Size(size.width - 16, height);
    calcRect();
    notifyListeners();
  }

  BlockerModel? get blockerModel => _blockerModel;

  void calcRect() async {
    Rect windowBound = await windowManager.getBounds();
    _blockerModel = BlockerModel(
        height: _blockerSize!.height,
        width: _blockerSize!.width,
        left: windowBound.left + 8,
        top: windowBound.top + titleBarHeight + 59);
  }

  void repeatingCallFrame(bool allowToGet) async {
    prevTimer?.cancel();
    prevTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (allowToGet) {
        blockerCaptureRequest(_blockerModel!);
        String? textCaptured = await textFromImage();
        if (textCaptured != prevText) {
          prevText = textCaptured ?? "";
          log(textCaptured.toString());
        }
      } else {
        timer.cancel();
      }
    });
  }

  void regionCapturing(bool allowToGet, List<RegionBoxState> _list) async {
    prevTimer?.cancel();
    prevTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (allowToGet) {
        for (var i in _list) {
          final model = BlockerModel(
              height: i.height,
              width: i.width,
              left: i.left + _blockerModel!.left,
              top: i.top + _blockerModel!.top);
          log(model.toList().toString());
          blockerCaptureRequest(model);
          String? textCaptured = await textFromImage();
          log(textCaptured.toString());
          if (textCaptured != prevText) {
            prevText = textCaptured ?? "";
          }
          log(textCaptured.toString());
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<String> callTextFromImage() async {
    return await textFromImage() ?? "";
  }

  Future<Uint8List> callBlockerCaptureFeed() async {
    blockerCaptureRequest(_blockerModel!);
    return await blockerCaptureFeed() ?? Uint8List(0);
  }

  Future<Uint8List> callFrame() async {
    return await frame() ?? Uint8List(0);
  }

  bool timeDifferenceBiggerThanSecond() {
    return DateTime.now().millisecondsSinceEpoch - lastTime > 1000;
  }
}
