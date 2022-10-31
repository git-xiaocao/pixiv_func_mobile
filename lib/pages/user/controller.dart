import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';

class UserController extends GetxController {
  final int id;

  UserController(this.id, TickerProvider vsync) : tabController = TabController(length: 4, vsync: vsync);
  final TabController tabController;
  final CancelToken cancelToken = CancelToken();

  UserDetailResult? userDetailResult;

  Restrict _restrict = Restrict.public;

  Restrict get restrict => _restrict;

  int _previousTabIndex = 0;

  bool _expandTypeSelector = false;

  bool get expandTypeSelector => _expandTypeSelector;

  PageState state = PageState.none;

  void restrictOnChanged(Restrict? value) {
    if (null != value) {
      _restrict = value;
      update();
    }
  }

  void loadData() {
    userDetailResult = null;
    state = PageState.loading;
    update();
    Get.find<ApiClient>().getUserDetail(id, cancelToken: cancelToken).then((result) {
      userDetailResult = result;
      state = PageState.complete;
    }).catchError((e) {
      if (e is DioError && HttpStatus.notFound == e.response?.statusCode) {
        state = PageState.notFound;
      } else {
        state = PageState.error;
      }
    }).whenComplete(() {
      update();
    });
  }

  void tabOnTap(int index) {
    if (!tabController.indexIsChanging && index == _previousTabIndex) {
      _expandTypeSelector = !_expandTypeSelector;
      update();
    }
  }

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    cancelToken.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    tabController.addListener(() {
      _previousTabIndex = tabController.index;
      update();
    });
    loadData();
    super.onInit();
  }
}

class MeController extends GetxController {
  MeController(TickerProvider vsync) : tabController = TabController(length: 5, vsync: vsync);
  final TabController tabController;
  final CancelToken cancelToken = CancelToken();

  int get currentUserId => Get.find<AccountService>().currentUserId;

  UserDetailResult? userDetailResult;

  Restrict _restrict = Restrict.public;

  Restrict get restrict => _restrict;

  int _previousTabIndex = 0;

  bool _expandTypeSelector = false;

  bool get expandTypeSelector => _expandTypeSelector;

  PageState state = PageState.none;

  void restrictOnChanged(Restrict? value) {
    if (null != value) {
      _restrict = value;
      update();
    }
  }

  void loadData() {
    userDetailResult = null;
    state = PageState.loading;
    update();
    Get.find<ApiClient>().getUserDetail(Get.find<AccountService>().currentUserId, cancelToken: cancelToken).then((result) {
      userDetailResult = result;
      state = PageState.complete;
    }).catchError((e) {
      //自己不会not found
      state = PageState.error;
    }).whenComplete(() {
      update();
    });
  }

  void tabOnTap(int index) {
    if (!tabController.indexIsChanging && index == _previousTabIndex) {
      _expandTypeSelector = !_expandTypeSelector;
      update();
    }
  }

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    cancelToken.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    tabController.addListener(() {
      _previousTabIndex = tabController.index;
      update();
    });
    loadData();
    super.onInit();
  }
}
