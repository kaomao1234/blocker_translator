import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowManagerService {
  void initailize() async {
     WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    final windowOptions = WindowOptions(
      backgroundColor: Colors.transparent,
      windowButtonVisibility: false,
    );
    await windowManager.waitUntilReadyToShow(windowOptions);
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
  }
}
