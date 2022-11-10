import 'dart:isolate';
import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/models/download_task.dart';

class Downloader extends GetxController implements GetxService {
  final List<DownloadTask> _tasks = [];

  List<DownloadTask> get tasks => _tasks;

  DownloadTask _taskByFilename(String filename) {
    return _tasks.singleWhere((task) => task.filename == filename);
  }

  bool _taskIsExist(String filename) {
    return _tasks.any((task) => task.filename == filename);
  }

  static Future<dynamic> _task(_DownloadStartProps props) async {
    final httpClient = Dio(
      BaseOptions(
        headers: const {'Referer': 'https://app-api.pixiv.net/'},
        responseType: ResponseType.bytes,
        sendTimeout: 6000,
        //60秒
        receiveTimeout: 60000,
        connectTimeout: 6000,
      ),
    );
    (httpClient.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) => client..badCertificateCallback = (cert, host, port) => true;

    final task = DownloadTask.create(
      index: props.index,
      illust: props.illust,
      originalUrl: props.originalUrl,
      url: props.url,
      filename: props.filename,
    );
    task.state = DownloadState.downloading;
    props.hostSendPort.send(task);
    try {
      final result = await httpClient.get<Uint8List>(
        props.url,
        onReceiveProgress: (int count, int total) {
          task.progress = count / total;
          props.hostSendPort.send(task);
        },
      );
      task.state = DownloadState.complete;
      props.hostSendPort.send(task);
      return _DownloadComplete(result.data!);
    } catch (e) {
      task.state = DownloadState.failed;
      props.hostSendPort.send(task);
      return _DownloadError();
    }
  }

  void start({
    required Illust illust,
    required String url,
    required int index,
    required void Function(int index, bool success)? onComplete,
  }) {
    final filename = url.substring(url.lastIndexOf('/') + 1);
    final imageUrl = Get.find<SettingsService>().toCurrentImageSource(url);

    final taskIndex = Get.find<Downloader>().tasks.indexWhere((task) => filename == task.filename);
    if (-1 != taskIndex && DownloadState.failed != Get.find<Downloader>().tasks[taskIndex].state) {
      PlatformApi.toast(I18n.illustIdDownloadTaskExists.trArgs(['${illust.id}[${index + 1}]']));
      return;
    }

    PlatformApi.toast(I18n.illustIdDownloadTaskStart.trArgs(['${illust.id}[${index + 1}]']));
    compute(
      _task,
      _DownloadStartProps(
        hostSendPort: _progressReceivePort.sendPort,
        illust: illust,
        originalUrl: url,
        url: imageUrl,
        filename: filename,
        index: index,
      ),
    ).then((result) async {
      if (result is _DownloadComplete) {
        final saveResult = await PlatformApi.saveImage(result.imageBytes, filename);

        onComplete?.call(index, saveResult);
        if (saveResult) {
          PlatformApi.toast(I18n.illustIdSaveSuccess.trArgs(['${illust.id}[${index + 1}]']));
        } else {
          PlatformApi.toast(I18n.illustIdSaveFailed.trArgs(['${illust.id}[${index + 1}]']));
        }
        onComplete?.call(index, true);
      } else if (result is _DownloadError) {
        PlatformApi.toast(I18n.illustIdSaveFailed.trArgs(['${illust.id}[${index + 1}]']));
        onComplete?.call(index, false);
      }
    });
  }

  late final ReceivePort _progressReceivePort = ReceivePort()..listen(_hostReceive);

  Future<void> _hostReceive(dynamic message) async {
    if (message is DownloadTask) {
      if (_taskIsExist(message.filename)) {
        final task = _taskByFilename(message.filename);
        //如果存在
        task.progress = message.progress;
        task.state = message.state;
      } else {
        //如果不存在
        _tasks.add(message);
      }
      update();
    }
  }
}

class _DownloadStartProps {
  final SendPort hostSendPort;
  final Illust illust;
  final String originalUrl;
  final String url;
  final String filename;
  final int index;

  _DownloadStartProps({
    required this.hostSendPort,
    required this.illust,
    required this.originalUrl,
    required this.url,
    required this.filename,
    required this.index,
  });
}

class _DownloadComplete {
  final Uint8List imageBytes;

  _DownloadComplete(this.imageBytes);
}

class _DownloadError {}
