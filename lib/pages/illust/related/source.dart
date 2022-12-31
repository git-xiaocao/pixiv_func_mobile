import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_dart_api/vo/illust_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/data_content/data_source_base.dart';

class IllustRelatedListSource extends DataSourceBase<Illust> {
  final int id;

  IllustRelatedListSource(this.id);

  final api = Get.find<ApiClient>();

  @override
  Future<List<Illust>> init(CancelToken cancelToken) {
    return api.getIllustRelatedPage(id, cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return result.illusts;
    });
  }

  @override
  Future<List<Illust>> next(CancelToken cancelToken) {
    return api.getNextPage<IllustPageResult>(nextUrl!, cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return result.illusts;
    });
  }

  @override
  String tag() => '$runtimeType-$id';
}
