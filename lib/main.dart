import 'dart:developer';

import 'package:auto_size_widget/auto_size_widget.dart';
import 'package:blocker_translator/logic/4handle_region_box.dart';
import 'package:blocker_translator/service/index.dart';
import 'package:blocker_translator/view/index.dart';
import 'package:blocker_translator/viewmodel/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WindowManagerService windowManagerService = WindowManagerService();
  windowManagerService.initailize();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<LandingViewModel>(
            create: (_) => LandingViewModel())
      ],
      builder: (context, child) {
        return MaterialApp(
          home: LandingView(),
        );
      }));
}

