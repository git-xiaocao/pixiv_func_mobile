import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/comment.dart';
import 'package:pixiv_dart_api/vo/comment_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/data_content/data_source_base.dart';
import 'package:pixiv_func_mobile/models/comment_tree.dart';

class IllustCommentListSource extends DataSourceBase<Comment> {
  final int id;

  IllustCommentListSource(this.id);

  final api = Get.find<ApiClient>();

  @override
  Future<List<Comment>> init(CancelToken cancelToken) {
    return api.getIllustCommentPage(id, cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return result.comments;
    });
  }

  @override
  Future<List<Comment>> next(CancelToken cancelToken) {
    return api.getNextPage<CommentPageResult>(nextUrl!, cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return result.comments;
    });
  }

  @override
  String tag() => '$runtimeType-$id';
}
