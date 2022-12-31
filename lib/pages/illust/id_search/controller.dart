import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/illust_detail_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';

class IllustIdSearchController extends GetxController {
  final int id;

  IllustIdSearchController(this.id);

  IllustDetailResult? illustDetail;

  final CancelToken cancelToken = CancelToken();

  final ApiClient api = Get.find<ApiClient>();

  PageState state = PageState.none;

  void loadData() {
    state = PageState.loading;
    update();
    api.getIllustDetail(id, cancelToken: cancelToken).then((result) {
      illustDetail = result;
      state = PageState.complete;
    }).catchError((e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        state = PageState.notFound;
      } else {
        state = PageState.error;
      }
    }).whenComplete(() {
      update();
    });
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
  }
}
