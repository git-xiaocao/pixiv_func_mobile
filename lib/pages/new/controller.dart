import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewController extends GetxController {
  NewController(TickerProvider vsync) : tabController = TabController(length: 3, vsync: vsync);
  final TabController tabController;

  bool _expandTypeSelector = false;

  bool get expandTypeSelector => _expandTypeSelector;

  int _previousTabIndex = 0;

  void tabOnTap(int index) {
    if (!tabController.indexIsChanging && index == _previousTabIndex) {
      _expandTypeSelector = !_expandTypeSelector;
      update();
    }
  }

  @override
  void onInit() {
    tabController.addListener(() {
      _previousTabIndex = tabController.index;
      update();
    });
    super.onInit();
  }
}
