import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' as html show parse;
import 'package:pixiv_dart_api/vo/novel_js_data.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';

class NovelController extends GetxController {
  final int id;

  NovelController(this.id);

  final CancelToken cancelToken = CancelToken();

  PageState state = PageState.none;

  NovelJSData? novelJSData;

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  NovelJSData decodeNovelHtml(html.Document document) {
    Map<String, dynamic>? json;
    const isOriginalFalse = '"isOriginal":false}';
    const isOriginalTrue = '"isOriginal":true}';
    bool isOriginal = false;
    final scriptTags = document.querySelectorAll('script');
    for (final scriptTag in scriptTags) {
      final text = scriptTag.text;
      if (text.contains('Object.defineProperty(window, \'pixiv\'')) {
        //novel : { "id":"123123", ...... []}
        final jsonStartIndex = text.indexOf('{', text.indexOf('novel'));

        int jsonEndIndex = text.indexOf(isOriginalFalse, jsonStartIndex);

        if (jsonEndIndex == -1) {
          jsonEndIndex = text.indexOf(isOriginalTrue, jsonStartIndex);
          isOriginal = true;
        }

        final jsonString = text.substring(jsonStartIndex, jsonEndIndex + (isOriginal ? isOriginalTrue.length : isOriginalFalse.length));

        json = jsonDecode(jsonString);

        break;
      }
    }

    return NovelJSData.fromJson(json!);
  }

  void loadData() async {
    state = PageState.loading;
    update();
    Get.find<ApiClient>().getNovelHtml(id, cancelToken: cancelToken).then((result) {
      novelJSData = decodeNovelHtml(html.parse(result));
      state = PageState.complete;
    }).catchError((e, s) {
      print(e);
      print(s);
      if (e is DioError && HttpStatus.notFound == e.response?.statusCode) {
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
