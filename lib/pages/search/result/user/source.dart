import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/user_preview.dart';
import 'package:pixiv_dart_api/vo/user_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/data_content/data_source_base.dart';

class SearchUserResultListSource extends DataSourceBase<UserPreview> {
  final String keyword;

  SearchUserResultListSource(this.keyword);

  final api = Get.find<ApiClient>();

  @override
  Future<List<UserPreview>> init(CancelToken cancelToken) {
    return api.getSearchUserPage(keyword, cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return result.userPreviews;
    });
  }

  @override
  Future<List<UserPreview>> next(CancelToken cancelToken) {
    return api.getNextPage<UserPageResult>(nextUrl!, cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return result.userPreviews;
    });
  }

  @override
  String tag() => '$runtimeType-$keyword';
}
