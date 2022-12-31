import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_dart_api/vo/novel_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/data_content/data_source_base.dart';

class RecommendedNovelListSource extends DataSourceBase<Novel> {
  final api = Get.find<ApiClient>();

  @override
  Future<List<Novel>> init(CancelToken cancelToken) {
    return api.getRecommendedNovelPage(cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return result.novels;
    });
  }

  @override
  Future<List<Novel>> next(CancelToken cancelToken) {
    return api.getNextPage<NovelPageResult>(nextUrl!, cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return result.novels;
    });
  }

  @override
  String tag() => '$runtimeType';
}
