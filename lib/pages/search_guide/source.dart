import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/trending_tag_list_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/data_content/data_source_base.dart';

class SearchTrendingIllustList extends DataSourceBase<TrendTag> {
  final api = Get.find<ApiClient>();

  @override
  Future<List<TrendTag>> init(CancelToken cancelToken) {
    return api
        .getTrendingTagList(
      cancelToken: cancelToken,
    )
        .then((result) {
      return result.trendTags;
    });
  }

  @override
  Future<List<TrendTag>> next(CancelToken cancelToken) {
    return Future.value([]);
  }

  @override
  String tag() => '$runtimeType';
}
