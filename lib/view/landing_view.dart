import 'dart:developer';

import 'package:blocker_translator/viewmodel/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> with WindowListener {
  bool isPlay = false;
  GlobalKey key = GlobalKey();
  // Size? blockerSize;

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
          )
        ]),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
          child: viewModel.imageBytes != null
              ? Center(
                  child: Image.memory(
                  viewModel.imageBytes!,
                ))
              : null),
    );
  }
}
