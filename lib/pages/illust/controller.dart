import 'dart:async';

import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_dart_api/model/tag.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/downloader/downloader.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/models/illust_save_state.dart';
import 'package:pixiv_func_mobile/pages/illust/comment/source.dart';
import 'package:pixiv_func_mobile/pages/illust/related/source.dart';
import 'package:pixiv_func_mobile/pages/illust/ugoira_viewer/controller.dart';
import 'package:pixiv_func_mobile/app/services/block_tag_service.dart';
import 'package:pixiv_func_mobile/app/db/history_db.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';

class IllustController extends GetxController {
  Illust illust;

  IllustController(this.illust)
      : illustCommentSource = IllustCommentListSource(illust.id),
        illustRelatedSource = IllustRelatedListSource(illust.id);

  final IllustCommentListSource illustCommentSource;

  final IllustRelatedListSource illustRelatedSource;

  final ExpandableController captionPanelController = ExpandableController();

  final CancelToken cancelToken = CancelToken();

  Timer? _addToHistoryTimer;

  final ScrollController scrollController = ScrollController();

  bool _showCaption = false;

  bool get showCaption => _showCaption;

  bool _downloadMode = false;

  bool get downloadMode => _downloadMode;

  bool _shieldMode = false;

  bool get blockMode => _shieldMode;

  Duration browsingDuration = Duration.zero;

  bool isVisibility = true;

  bool downloaded = false;

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
      PlatformApi.toast(I18n.unblockTag.trArgs([tag.name]));
    } else {
      blockTagService.add(tag);
      PlatformApi.toast(I18n.blockTag.trArgs([tag.name]));
    }
    update();
  }

  void showCommentChangeState() {
    _showCaption = !_showCaption;
    captionPanelController.expanded = _showCaption;
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
    downloaded = true;
    Get.find<UgoiraViewerController>(tag: 'UgoiraViewer-${illust.id}').save();
    illustStates[0] = IllustSaveState.downloading;
    update();
  }

  void download(int index) {
    downloaded = true;
    final String url;
    if (illust.pageCount > 1) {
      url = illust.metaPages[index].imageUrls.original!;
    } else {
      url = illust.metaSinglePage.originalImageUrl!;
    }
    illustStates[index] = IllustSaveState.downloading;
    update();
    Get.find<Downloader>().start(
      illust: illust,
      url: url,
      index: index,
      onComplete: downloadComplete,
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
  void onClose() {
    illustRelatedSource.dispose();
    illustCommentSource.dispose();
    cancelToken.cancel();
    _addToHistoryTimer?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        if (scrollController.offset != scrollController.position.maxScrollExtent) {
          FocusScopeNode currentFocus = FocusScope.of(Get.context!);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        }
      }
    });
    initIllustStates();

    if (Get.find<SettingsService>().enableHistory) {
      HistoryDB.exist(illust.id).then(
        (exist) {
          if (!exist) {
            HistoryDB.insert(illust);
          }
        },
      );
    }

    _addToHistoryTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        //下载了 或者 浏览时长大于10秒
        if (downloaded || browsingDuration > const Duration(seconds: 10)) {
          Get.find<ApiClient>().postBrowserHistoryAdd(illustIds: [illust.id]);
          _addToHistoryTimer?.cancel();
          _addToHistoryTimer = null;
        } else {
          //如果还在这个插画页面就加一秒
          if (isVisibility) {
            browsingDuration += const Duration(seconds: 1);
          }
        }
      },
    );

    super.onInit();
  }
}
