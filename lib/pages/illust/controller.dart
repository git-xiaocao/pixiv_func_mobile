import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_dart_api/model/tag.dart';
import 'package:pixiv_dart_api/vo/comment_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/data/block_tag_service.dart';
import 'package:pixiv_func_mobile/app/data/history_service.dart';
import 'package:pixiv_func_mobile/app/data/settings_service.dart';
import 'package:pixiv_func_mobile/app/downloader/downloader.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/models/comment_tree.dart';
import 'package:pixiv_func_mobile/models/illust_save_state.dart';
import 'package:pixiv_func_mobile/pages/illust/comment/source.dart';
import 'package:pixiv_func_mobile/pages/illust/related/source.dart';
import 'package:pixiv_func_mobile/pages/illust/ugoira_viewer/controller.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class IllustController extends GetxController {
  Illust illust;

  IllustController(this.illust)
      : illustCommentSource = IllustCommentListSource(illust.id),
        illustRelatedSource = IllustRelatedListSource(illust.id);

  final IllustCommentListSource illustCommentSource;

  final IllustRelatedListSource illustRelatedSource;

  final TextEditingController commentInput = TextEditingController();

  final captionPanelController = ExpandableController();

  final CancelToken cancelToken = CancelToken();

  CommentTree? _repliesCommentTree;

  CommentTree? get repliesCommentTree => _repliesCommentTree;

  double _previousOffset = 0;

  bool _showInputBox = false;

  bool get showInputBox => _showInputBox;

  final scrollController = ScrollController();

  set repliesCommentTree(CommentTree? value) {
    _repliesCommentTree = value;
    update();
  }

  bool get isReplies => null != _repliesCommentTree;

  String get commentInputLabel => isReplies ? '?????? ${repliesCommentTree!.data.user.name}' : '?????? ??????';

  bool _showComment = false;

  bool get showCaption => _showComment;

  bool _downloadMode = false;

  bool get downloadMode => _downloadMode;

  bool _shieldMode = false;

  bool get blockMode => _shieldMode;

  final Map<int, IllustSaveState> illustStates = {};

  final BlockTagService blockTagService = Get.find();

  void downloadModeChangeState() {
    _downloadMode = !_downloadMode;
    update();
  }

  void blockModeChangeState() {
    _shieldMode = !_shieldMode;
    update();
  }

  void blockTagChangeState(Tag tag) {
    if (blockTagService.isBlocked(tag)) {
      blockTagService.remove(tag);
      PlatformApi.toast('????????????:${tag.name}');
    } else {
      blockTagService.add(tag);
      PlatformApi.toast('????????????:${tag.name}');
    }
    update();
  }

  void loadFirstReplies(CommentTree commentTree) {
    commentTree.loading = true;
    illustCommentSource.setState();
    if (commentTree.data.hasReplies) {
      Get.find<ApiClient>().getCommentReplyPage(commentTree.data.id, cancelToken: cancelToken).then((result) {
        commentTree.children.addAll(result.comments.map((e) => CommentTree(data: e, parent: commentTree)));
        commentTree.nextUrl = result.nextUrl;
      }).catchError((e) {
        Log.e('??????????????????', e);
      }).whenComplete(() {
        commentTree.loading = false;
        illustCommentSource.setState();
      });
    }
  }

  void loadNextReplies(CommentTree commentTree) {
    if (commentTree.hasNext) {
      commentTree.loading = true;
      illustCommentSource.setState();
      Get.find<ApiClient>().getNextPage<CommentPageResult>(commentTree.nextUrl!, cancelToken: cancelToken).then((result) {
        commentTree.children.addAll(result.comments.map((e) => CommentTree(data: e, parent: commentTree)));
        commentTree.nextUrl = result.nextUrl;
      }).catchError((e) {
        Log.e('???????????????????????????', e);
      }).whenComplete(() {
        commentTree.loading = false;
        illustCommentSource.setState();
      });
    }
  }

  void onCommentAdd() {
    final commentTree = repliesCommentTree;
    final content = commentInput.text;
    commentInput.clear();
    Get.find<ApiClient>().postCommentAdd(illust.id, comment: content, parentCommentId: commentTree?.data.id).then((result) {
      if (null != commentTree) {
        commentTree.children.insert(0, CommentTree(data: result.comment, parent: commentTree));
        illustCommentSource.setState();
        PlatformApi.toast('????????????');
      } else {
        illustCommentSource.insert(0, CommentTree(data: result.comment, parent: null));
        illustCommentSource.setState();
        PlatformApi.toast('????????????');
      }
    }).catchError((e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        PlatformApi.toast('????????????,???????????????????????????');
      } else {
        PlatformApi.toast('????????????,?????????');
      }
      Log.e('????????????', e);
    });
  }

  void onCommentDelete(
    CommentTree commentTree,
  ) {
    Get.find<ApiClient>().postCommentDelete(commentTree.data.id).then((value) {
      if (null == commentTree.parent) {
        illustCommentSource.removeWhere((element) => commentTree.data.id == element.data.id);
        illustCommentSource.setState();
      } else {
        commentTree.parent!.children.removeWhere((element) => commentTree.data.id == element.data.id);
        illustCommentSource.setState();
      }
      PlatformApi.toast('??????????????????');
    }).catchError((e) {
      Log.e('??????????????????', e);
      PlatformApi.toast('??????????????????');
    });
  }

  void showCommentChangeState() {
    _showComment = !_showComment;
    captionPanelController.expanded = _showComment;
    update();
  }

  void initIllustStates() async {
    if (illust.isUgoira) {
      illustStates[0] = await PlatformApi.imageIsExist('${illust.id}.gif') ? IllustSaveState.exist : IllustSaveState.none;
    } else {
      final urls = <String>[];
      if (illust.pageCount > 1) {
        urls.addAll(illust.metaPages.map((e) => e.imageUrls.original!));
      } else {
        urls.add(illust.metaSinglePage.originalImageUrl!);
      }
      for (int i = 0; i < urls.length; ++i) {
        final url = urls[i];
        final filename = url.substring(url.lastIndexOf('/') + 1);

        illustStates[i] = await PlatformApi.imageIsExist(filename) ? IllustSaveState.exist : IllustSaveState.none;
      }
    }
  }

  void downloadGif() {
    Get.find<UgoiraViewerController>(tag: 'UgoiraViewer-${illust.id}').save();
    illustStates[0] = IllustSaveState.downloading;
    update();
  }

  void download(int index) {
    final String url;
    if (illust.pageCount > 1) {
      url = illust.metaPages[index].imageUrls.original!;
    } else {
      url = illust.metaSinglePage.originalImageUrl!;
    }
    illustStates[index] = IllustSaveState.downloading;
    update();
    Downloader.start(
      illust: illust,
      url: url,
      id: illust.id,
      index: index,
    );
  }

  void downloadComplete(int index, bool success) {
    if (success) {
      illustStates[index] = IllustSaveState.exist;
      update();
    } else {
      illustStates[index] = IllustSaveState.error;
      update();
    }
  }

  void downloadAll() {
    for (int i = 0; i < illustStates.length; ++i) {
      download(i);
    }
  }

  @override
  void dispose() {
    illustRelatedSource.dispose();
    illustCommentSource.dispose();
    cancelToken.cancel();
    super.dispose();
  }

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        _showInputBox = _previousOffset < scrollController.offset;
        update();
        _previousOffset = scrollController.offset;
      }
    });
    initIllustStates();
    if (Get.find<SettingsService>().enableHistory) {
      Get.find<HistoryService>().exist(illust.id).then(
        (exist) {
          if (!exist) {
            Get.find<HistoryService>().insert(illust);
          }
        },
      );
    }
    super.onInit();
  }
}
