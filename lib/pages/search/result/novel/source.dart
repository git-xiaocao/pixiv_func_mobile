import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_dart_api/vo/novel_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/data_content/data_source_base.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';

import 'filter_editor/controller.dart';

class SearchNovelResultListSource extends DataSourceBase<Novel> {
  final String word;

  SearchNovelResultListSource(this.word);

  final api = Get.find<ApiClient>();

  @override
  Future<List<Novel>> init(CancelToken cancelToken) {
    final SearchNovelFilter filter = Get.find<SearchNovelFilterEditorController>(tag: '$word').filter;
    return api
        .getSearchNovelPage(
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
  String tag() => '$runtimeType-$word';
}
