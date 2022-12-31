import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_dart_api/vo/novel_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/data_content/data_source_base.dart';

class FollowNewNovelListSource extends DataSourceBase<Novel> {
  final Restrict? restrict;

  FollowNewNovelListSource(this.restrict);

  final api = Get.find<ApiClient>();

  @override
  Future<List<Novel>> init(CancelToken cancelToken) {
    return api.getFollowNewNovelPage(restrict: restrict, cancelToken: cancelToken).then((result) {
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
  String tag() => '$runtimeType-$restrict';
}
