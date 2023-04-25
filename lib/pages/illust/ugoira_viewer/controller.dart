import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/pages/illust/controller.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

import 'state.dart';

class UgoiraViewerController extends GetxController {
  final int id;

  UgoiraViewerController(this.id);

  final UgoiraViewerState state = UgoiraViewerState();

  final CancelToken cancelToken = CancelToken();

  final Dio _httpClient = Dio(
    BaseOptions(
      headers: {'Referer': 'https://app-api.pixiv.net/'},
      responseType: ResponseType.bytes,
      sendTimeout: const Duration(seconds: 6),
      //60秒
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 6),
    ),
  );

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  Future<ui.Image> _loadImage(Uint8List bytes) async {
    final coder = await ui.instantiateImageCodec(bytes);

    final frame = await coder.getNextFrame();

    return frame.image;
  }

  Future<bool> loadData() async {
    state.loading = true;
    update();
    if (null == state.ugoiraMetadata) {
      PlatformApi.toast(I18n.startGetUgoiraInfo.tr);
      try {
        state.ugoiraMetadata = await Get.find<ApiClient>().getUgoiraMetadata(id, cancelToken: cancelToken);
        state.delays.addAll(state.ugoiraMetadata!.ugoiraMetadata.frames.map((frame) => frame.delay));
        Log.i('获取动图信息成功');
      } catch (e) {
        Log.e('获取动图信息失败', e);
        PlatformApi.toast(I18n.getUgoiraInfoFailed.tr);
        state.loading = false;
        return false;
      }
    }

    if (null == state.gifZipResponse) {
      PlatformApi.toast(I18n.startDownloadUgoira.tr);
      try {
        state.gifZipResponse = await _httpClient.get<Uint8List>(
          Get.find<SettingsService>().toCurrentImageSource(state.ugoiraMetadata!.ugoiraMetadata.zipUrls.medium),
          options: Options(receiveTimeout: const Duration(seconds: 60)),
        );
      } catch (e) {
        Log.e('下载动图压缩包失败', e);
        PlatformApi.toast(I18n.downloadUgoiraFailed.tr);
        state.loading = false;
        return false;
      }
    }

    if (state.imageFiles.isEmpty) {
      state.imageFiles.addAll(await PlatformApi.unZipGif(state.gifZipResponse!.data!));
    }

    state.loaded = true;

    return true;
  }

  Future<void> _generateImages() async {
    PlatformApi.toast(I18n.startGenerateImage.trArgs([state.imageFiles.length.toString()]));
    bool init = false;
    for (final imageBytes in state.imageFiles) {
      state.images.add(await _loadImage(imageBytes));
      if (!init) {
        init = true;
        final previewWidth = Get.mediaQuery.size.width;

        final previewHeight = previewWidth / state.images.first.width * state.images.first.height.toDouble();
        state.size = ui.Size(previewWidth, previewHeight.toDouble());
      }
    }
  }

  void play() {
    Future.sync(_playRoutine);
  }

  void save() {
    Future.sync(_saveRoutine);
  }

  Future<void> _playRoutine() async {
    if (state.loading) {
      Future.delayed(const Duration(milliseconds: 333), _playRoutine);
    } else {
      if (state.loaded || !state.loaded && await loadData()) {
        await _generateImages();
        state.loading = false;
        state.init = true;
        update();
      }
    }
  }

  Future<void> _saveRoutine() async {
    if (state.loading) {
      Future.delayed(const Duration(milliseconds: 333), _saveRoutine);
    } else {
      if (state.loaded || !state.loaded && await loadData()) {
        state.loading = false;
        update();
        PlatformApi.toast(I18n.startCompositeImage.trArgs([state.imageFiles.length.toString()]));
        final saveResult = await PlatformApi.saveGifImage(id, state.imageFiles, state.delays);

        if (Get.isRegistered<IllustController>(tag: '$id')) {
          Get.find<IllustController>(tag: '$id').downloadComplete(0, saveResult);
        } else {
          if (saveResult) {
            PlatformApi.toast(I18n.illustIdSaveSuccess.trArgs([id.toString()]));
          } else {
            PlatformApi.toast(I18n.illustIdSaveFailed.trArgs([id.toString()]));
          }
        }
      }
    }
  }
}
