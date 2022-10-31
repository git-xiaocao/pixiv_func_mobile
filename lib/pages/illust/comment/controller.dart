import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/comment.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

import 'source.dart';

class IllustCommentController extends GetxController {
  final int id;

  IllustCommentController(this.id) : source = IllustCommentListSource(id);

  final IllustCommentListSource source;

  final CancelToken cancelToken = CancelToken();

  Comment? _repliesComment;

  Comment? get repliesComment => _repliesComment;

  set repliesComment(Comment? value) {
    _repliesComment = value;
    update();
  }

  bool get isReplies => null != _repliesComment;

  String get commentInputLabel => isReplies ? I18n.replyComment.trArgs([_repliesComment!.user.name]) : I18n.commentIllust.tr;

  void onCommentAdd({String? text, int? stampId}) {
    Get.find<ApiClient>().postCommentAdd(id, comment: text, parentCommentId: repliesComment?.id, stampId: stampId).then((result) {
      if (null != repliesComment) {
        for (int i = 0; i < source.length; i++) {
          if (source[i].id == result.comment.id) {
            source[i] = result.comment;
          }
        }
        source.setState();
        PlatformApi.toast(I18n.replySuccessHint.tr);
      } else {
        source.insert(0, result.comment);
        source.setState();
        PlatformApi.toast(I18n.commentSuccessHint.tr);
      }
    }).catchError((e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        PlatformApi.toast(I18n.replyFailedHint.tr);
      } else {
        PlatformApi.toast(I18n.commentFailedHint.tr);
      }
      Log.e('评论异常', e);
    });
  }

  void onCommentDelete(
    Comment comment,
  ) {
    Get.find<ApiClient>().postCommentDelete(comment.id).then((value) {
      source.removeWhere((element) => comment.id == element.id);
      source.setState();
      PlatformApi.toast(I18n.deleteCommentSuccessHint.tr);
    }).catchError((e) {
      Log.e('删除评论失败', e);
      PlatformApi.toast(I18n.deleteCommentFailedHint.tr);
    });
  }

  @override
  void onClose() {
    cancelToken.cancel();
    super.onClose();
  }
}
