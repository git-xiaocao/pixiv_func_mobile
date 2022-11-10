import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_dart_api/vo/illust_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/data_content/data_source_base.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';

import 'filter_editor/controller.dart';

class SearchIllustResultListSource extends DataSourceBase<Illust> {
  final String word;

  SearchIllustResultListSource(this.word);

  final api = Get.find<ApiClient>();

  @override
  Future<List<Illust>> init(CancelToken cancelToken) {
    final SearchIllustFilter filter = Get.find<SearchIllustFilterEditorController>(tag: '$word').filter;
    return api
        .getSearchIllustPage(
      word,
      filter.sort,
      filter.target,
      startDate: filter.enableDateRange ? filter.formatStartDate : null,
      endDate: filter.enableDateRange ? filter.formatEndDate : null,
      bookmarkTotal: filter.bookmarkTotal,
      cancelToken: cancelToken,
    )
        .then((result) {
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
  String tag() => '$runtimeType-$word';
}
