import 'dart:developer';
import 'dart:typed_data';

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
  final imageBytesNotifier = ValueNotifier<Uint8List?>(null);

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
      viewModel.repeatingCallFrame(isPlay, (imageBytes) {
        imageBytesNotifier.value = imageBytes;
      });
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
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              viewModel.rectangleModel!.toList().toString(),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            )
          ]),
        ),
        backgroundColor: Colors.transparent,
        body: ValueListenableBuilder(
          valueListenable: imageBytesNotifier,
          builder: (context, value, child) {
            if (value != null) {
              return Image.memory(value);
            } else {
              return Container();
            }
          },
        ));
  }
}
