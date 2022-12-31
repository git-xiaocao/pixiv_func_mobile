import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FrameGifController extends GetxController with WidgetsBindingObserver {
  final List<ui.Image> images;
  final List<int> delays;

  FrameGifController(
    this.images,
    this.delays,
  );

  final ValueNotifier<int> indexValueNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> pauseValueNotifier = ValueNotifier<bool>(false);

  bool isActivity = true;

  bool playing = false;

  bool get isPause => pauseValueNotifier.value;

  void pauseStateChange() {
    pauseValueNotifier.value = !isPause;
    update();
  }

  Future<void> start() async {
    playing = true;
    update();
    Future.sync(_updateRender);
  }

  void stop() {
    playing = false;
    update();
  }

  void _updateRender() {
    Future.delayed(
      Duration(milliseconds: delays[indexValueNotifier.value]),
      () {
        if (!isPause) {
          if (indexValueNotifier.value == images.length - 1) {
            indexValueNotifier.value = 0;
          } else {
            indexValueNotifier.value++;
          }
        }
        if (playing && isActivity) {
          _updateRender();
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    isActivity = state == AppLifecycleState.resumed;
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onClose() {
    pauseValueNotifier.value = true;
    playing = false;
    super.onClose();
  }
}
