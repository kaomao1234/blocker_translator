import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:blocker_translator/api/frame.dart';
import 'package:flutter/material.dart';

class LandingViewModel with ChangeNotifier {
  Size? _blockerSize;
  Size? get getblockerSize => _blockerSize;
  Uint8List? imageBytes;
  set setblockerSize(Size blockerSize) {
    _blockerSize = blockerSize;
    notifyListeners();
  }

  void repeatingCallFrame(bool allowToGet) async {
    Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      if (allowToGet) {
        imageBytes = await frame();
      } else {
        imageBytes = null;
        timer.cancel();
      }
      notifyListeners();
    });
  }
}
