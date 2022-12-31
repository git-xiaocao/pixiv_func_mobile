import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' as html show parse;
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/models/search_image_item.dart';
import 'package:pixiv_func_mobile/models/search_image_result.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class SearchImageResultController extends GetxController {
  final Uint8List imageBytes;
  final String filename;

  SearchImageResultController({required this.imageBytes, required this.filename});

  final list = <SearchImageItem>[];

  final httpClient = Dio(BaseOptions(
    sendTimeout: 60000,
  ));

  final CancelToken cancelToken = CancelToken();

  PageState state = PageState.none;

  void loadItem(SearchImageItem item) {
    item.loading = true;
    update();
    Get.find<ApiClient>().getIllustDetail(item.result.illustId, cancelToken: cancelToken).then((result) {
      item.loading = false;
      item.illust = result.illust;
      update();
    }).catchError((e, s) {
      item.loading = false;
      if (e is DioError && HttpStatus.notFound == e.response?.statusCode) {
        remove(item.result.illustId);
      } else {
        item.loadFailed = true;
      }
      update();
    });
  }

  void remove(int id) {
    list.removeWhere((item) => id == item.result.illustId);
  }

  Future<void> loadData() async {
    list.clear();
    state = PageState.loading;
    update();
    final fromData = FormData()
      ..files.add(
        MapEntry(
          'file',
          MultipartFile.fromBytes(imageBytes, filename: filename),
        ),
      );

    httpClient.post<String>('https://saucenao.com/search.php', data: fromData, cancelToken: cancelToken).then((response) {
      final document = html.parse(response.data!);
      final resultList = decodeSearchHtml(document);
      //相似度大到小排序
      resultList.sort(
        (a, b) => double.parse(a.similarityText.replaceAll('%', '')) > double.parse(b.similarityText.replaceAll('%', '')) ? -1 : 1,
      );

      //去除illustId相同的
      final tempList = <SearchImageResult>[];
      for (final result in resultList) {
        if (tempList.isEmpty) {
          tempList.add(result);
        } else {
          if (!result.isPixivIllust) {
            tempList.add(result);
          } else if (!tempList.any((element) => element.isPixivIllust && result.illustId == element.illustId)) {
            tempList.add(result);
          }
        }
      }
      resultList.clear();
      resultList.addAll(tempList);

      for (final result in resultList) {
        list.add(SearchImageItem(result));
      }

      for (final item in list) {
        if (item.result.isPixivIllust) {
          loadItem(item);
        }
      }
      state = PageState.complete;
    }).catchError((e, s) {
      if (e is DioError && e.response?.statusCode == HttpStatus.tooManyRequests) {
        PlatformApi.toast(I18n.searchImageStatus429Hint.tr);
      }
      Log.e('搜索图片失败', e);
      state = PageState.error;
    }).whenComplete(() {
      update();
    });
  }

  List<SearchImageResult> decodeSearchHtml(html.Document document) {
    final list = <SearchImageResult>[];
    //div
    document.querySelectorAll('.result').forEach((result) {
      final resultImageDiv = result.querySelector('.resultimage');
      //低相似度隐藏
      if (null == resultImageDiv) {
        return;
      }

      final resultSimilarityInfoDiv = result.querySelector('.resultsimilarityinfo')!;

      final resultMiscInfoDiv = result.querySelector('.resultmiscinfo')!;

      final resultContentColumnDiv = result.querySelector('.resultcontentcolumn')!;

      final imageUrl = resultImageDiv.querySelectorAll('img').lastWhere((element) => element.id.contains('resImage')).attributes['src']!;

      //地相似度隐藏 没必要显示出来
      if ('images/static/blocked.gif' == imageUrl) {
        return;
      }

      final sourceUrl = resultContentColumnDiv.querySelector('a')?.attributes['href'];

      final sourceText = resultContentColumnDiv.querySelector('a')?.text;

      final similarityText = resultSimilarityInfoDiv.text;

      final miscInfoList = resultMiscInfoDiv.querySelectorAll('a');

      list.add(
        SearchImageResult(
          imageUrl: imageUrl,
          sourceUrl: sourceUrl,
          sourceText: sourceText,
          similarityText: similarityText,
          miscInfoList: miscInfoList.map((miscInfo) {
            return SearchImageMiscInfo(
              url: miscInfo.attributes['href']!,
              imageUrl: miscInfo.querySelector('img')!.attributes['src']!,
            );
          }).toList(),
        ),
      );
    });

    return list;
  }

  Future<void> openUrl(String url) async {
    PlatformApi.urlLaunch(url);
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
  }
}
