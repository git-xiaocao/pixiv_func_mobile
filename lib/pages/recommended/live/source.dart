import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/live.dart';
import 'package:pixiv_dart_api/vo/live_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/data_content/data_source_base.dart';

class RecommendedLiveListSource extends DataSourceBase<Live> {
  RecommendedLiveListSource();

  final api = Get.find<ApiClient>();

  @override
  Future<List<Live>> init(CancelToken cancelToken) {
    return api.getLivePage(cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return result.lives;
    });
  }

  @override
  Future<List<Live>> next(CancelToken cancelToken) {
    return api.getNextPage<LivePageResult>(nextUrl!, cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return result.lives;
    });
  }

  @override
  String tag() => '$runtimeType';
}
