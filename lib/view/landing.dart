import 'dart:developer';

import 'package:blocker_translator/hooks/region_box.dart';
import 'package:blocker_translator/viewmodel/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isEdit = false;
  late String currentMode = viewModel.mode.keys.first;
  late List<RegionBoxState> regionBoxStates = [];
  bool isIgnoreMouse = false;
  // final blockerSizeNotifier = ValueNotifier<Size>(Size.zero);
  LandingViewModel get viewModel =>
      Provider.of<LandingViewModel>(context, listen: false);

  @override
  void initState() {
    regionBoxStates.addAll(viewModel.regionBoxs);
    ServicesBinding.instance.keyboard.addHandler(onKeyPress);
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(onKeyPress);
    windowManager.removeListener(this);
    super.dispose();
  }

  bool onKeyPress(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    // if (event is KeyDownEvent) {
    //   if (key == "Pause") {
    //     isIgnoreMouse = !isIgnoreMouse;
    //     () async {
    //       await windowManager.setIgnoreMouseEvents(isIgnoreMouse);
    //     }();
    //     log("Key down: $key");
    //   }
    // }
    // } else if (event is KeyUpEvent) {
    //   log("Key up: $key");
    // } else if (event is KeyRepeatEvent) {
    //   log("Key repeat: $key");
    // }

    return false;
  }

  void onPlayPress() {
    setState(() {
      isPlay = !isPlay;
      viewModel.mode[currentMode]!(isPlay);
      if (isPlay) {
        regionBoxStates.clear();
      } else {
        regionBoxStates.addAll(viewModel.regionBoxs);
      }
    });
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
          for (var i in regionBoxStates)
            RegionBox(state: i, hook: setState, areaSize: size)
        ],
      ),
    );
  }

  Widget regionTab() {
    return Flexible(
        child: Row(
      children: [
        TextButton(
            onPressed: () {
              viewModel.clearRegion();
            },
            child: Text(
              "clear",
              style: TextStyle(fontSize: 16, color: Colors.red),
            )),
        TextButton.icon(
            onPressed: () {
              setState(() {
                viewModel.addRegion(RegionBoxState());
                regionBoxStates.clear();
                regionBoxStates.addAll(viewModel.regionBoxs);
              });
            },
            icon: Icon(Icons.add),
            label: Text("Add rectangle")),
      ],
    ));
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
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
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
            SizedBox(
              width: 10,
            ),
            DropdownButton(
                value: currentMode,
                onChanged: (String? value) {
                  setState(() {
                    currentMode = value!;
                    isSwicthMode = !isSwicthMode;
                  });
                },
                items: viewModel.mode.keys
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                    .toList()),
            currentMode == "region mode" ? regionTab() : SizedBox()
          ]),
        ),
        backgroundColor: Colors.transparent,
        body: isSwicthMode
            ? drawableRectangle(viewModel.getblockerSize!)
            : Container());
  }
}
