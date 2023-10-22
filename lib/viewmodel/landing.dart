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
  List<RegionBoxState> regionBoxs = [];
  late Map<String, Function> mode = {
    "blocker mode": frameDetection,
    "region mode": regionDetection,
  };
  int lastTime = DateTime.now().millisecondsSinceEpoch;
  void calcblockerSize() async {
    titleBarHeight = await windowManager.getTitleBarHeight();
    Size size = await windowManager.getSize();
    double height = size.height - titleBarHeight - 40 - 11;
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
        top: windowBound.top + titleBarHeight + 40 + 3);
  }

  void frameDetection(bool isPlay) async {
    log(isPlay.toString());
    prevTimer?.cancel();
    String prevText = "";
    prevTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (isPlay) {
        blockerDetectorRequest(blockerModel!);
        String? textDetected = await blockerDetector();
        if (textDetected != prevText) {
          prevText = textDetected ?? "";
          log(textDetected.toString());
        }
      } else {
        timer.cancel();
      }
    });
  }

  void addRegion(RegionBoxState regionBoxState) {
    regionBoxs.add(regionBoxState);
    notifyListeners();
  }

  void clearRegion() {
    regionBoxs.clear();
    notifyListeners();
  }

  void regionDetection(bool isPlay) async {
    prevTimer?.cancel();
    String prevText = "";
    prevTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (isPlay) {
        blockerDetectorRequest(blockerModel!);
        for (var i in regionBoxs) {
          final model = BlockerModel(
              height: i.height, width: i.width, left: i.left, top: i.top);
          regionDetectorRequest(model);
          String? textDetected = await regionDetector();
          if (textDetected != prevText) {
            prevText = textDetected ?? "";
            log(textDetected.toString());
          }
        }
      } else {
        timer.cancel();
      }
    });
  }
}
