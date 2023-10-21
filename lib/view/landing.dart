import 'package:blocker_translator/hooks/region_box.dart';
import 'package:blocker_translator/viewmodel/index.dart';
import 'package:flutter/material.dart';
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
  List<RegionBoxState> regionBoxStates = [];
  final blockerSizeNotifier = ValueNotifier<Size>(Size.zero);
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
      if (!isSwicthMode) {
        viewModel.frameDetection(isPlay);
      } else {
        viewModel.regionDetection(isPlay, regionBoxStates);
      }
    });
  }

  @override
  void onWindowEvent(String eventName) {
    viewModel.calcblockerSize();
    super.onWindowEvent(eventName);
  }

  Widget drawableRectangle(Size size) {
    void onRegionBoxPositionUpdate(
        DragUpdateDetails details, RegionBoxState state) {
      setState(() {
        double top = details.delta.dy, left = details.delta.dx;
        state.top += top;
        state.left += left;
        double bottom = state.top + state.height;
        double right = state.left + state.width;
        double maxTop = size.height - state.height;
        double maxLeft = size.width - state.width;
        state.top = state.top < 0 ? 0 : state.top;
        state.left = state.left < 0 ? 0 : state.left;
        state.top = bottom > size.height ? maxTop : state.top;
        state.left = right > size.width ? maxLeft : state.left;
      });
    }

    void onRegionBoxSizeUpdate(
        DragUpdateDetails details, RegionBoxState state) {
      setState(() {
        state.width += details.delta.dx;
        state.height += details.delta.dy;
        state.width = state.width <= 0 ? 100 : state.width;
        state.height = state.height <= 0 ? 100 : state.height;
      });
    }

    return SizedBox(
      width: size.width > 0 ? size.width : null,
      height: size.height > 0 ? size.height : null,
      child: Stack(
        children: [
          for (var i in regionBoxStates)
            RegionBox(
                state: i,
                boxPositionUpdate: onRegionBoxPositionUpdate,
                boxSizeUpdate: onRegionBoxSizeUpdate)
        ],
      ),
    );
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
    blockerSizeNotifier.value = viewModel.getblockerSize!;
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
            SizedBox(
              width: 10,
            ),
            TextButton(
              child: Text(
                isSwicthMode ? "rectangle mode" : "blocker mode",
                style: TextStyle(
                    fontSize: 16,
                    color: !isSwicthMode ? Colors.black : Colors.blue),
              ),
              onPressed: () {
                setState(() {
                  isSwicthMode = !isSwicthMode;
                  // viewModel.prevTimer!.cancel();
                });
              },
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    regionBoxStates.clear();
                  });
                },
                child: Text(
                  "clear",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                )),
            TextButton.icon(
                onPressed: () {
                  setState(() {
                    regionBoxStates.add(RegionBoxState());
                  });
                },
                icon: Icon(Icons.add),
                label: Text("Add rectangle")),
            SizedBox(
              width: 150,
              child: CheckboxListTile(
                value: isEdit,
                onChanged: (bool? val) {
                  setState(() {
                    isEdit = val!;
                    for (var i in regionBoxStates) {
                      i.isEdit = isEdit;
                    }
                  });
                },
                title: Text("Edit mode"),
              ),
            )
          ]),
        ),
        backgroundColor: Colors.transparent,
        body: isSwicthMode
            ? ValueListenableBuilder(
                valueListenable: blockerSizeNotifier,
                builder: (context, value, child) {
                  return drawableRectangle(value);
                },
              )
            : Container());
  }
}
