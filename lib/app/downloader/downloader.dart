import 'dart:isolate';
import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/models/download_task.dart';
import 'package:pixiv_func_mobile/pages/illust/controller.dart';
import 'package:pixiv_func_mobile/utils/log.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';

import 'download_manager_controller.dart';

class Downloader {
  static int _idCount = 0;

  static int get _currentId => _idCount++;

  static final ReceivePort _hostReceivePort = ReceivePort()..listen(_hostReceive);

  static Future<void> _hostReceive(dynamic message) async {
    if (message is DownloadTask) {
      final index = Get.find<DownloadManagerController>().tasks.indexWhere((task) => message.filename == task.filename);
      if (-1 != index) {
        //如果存在
        Get.find<DownloadManagerController>().tasks[index] = message;
        Get.find<DownloadManagerController>().stateChange(index, (task) {
          task.progress = message.progress;
          task.state = message.state;
        });
      } else {
        //如果不存在
        Get.find<DownloadManagerController>().add(message);
      }
    } else if (message is _DownloadComplete) {
      final saveResult = await PlatformApi.saveImage(message.imageBytes, message.filename);
      if (null == saveResult) {
        PlatformApi.toast('图片已经存在');
        return;
      }
      if (Get.isRegistered<IllustController>(tag: 'IllustPage-${message.id}')) {
        Get.find<IllustController>(tag: 'IllustPage-${message.id}').downloadComplete(message.index, saveResult);
      } else {
        Log.i('没有IllustId为:${message.id}的控制器');
      }
      if (saveResult) {
        PlatformApi.toast('保存成功');
      } else {
        PlatformApi.toast('保存失败');
      }
    } else if (message is _DownloadError) {
      PlatformApi.toast('下载失败');
    }
  }

  static Future<void> _task(_DownloadStartProps props) async {
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
    (httpClient.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
      return client;
    };

    if (null != props.illust) {
      final task = DownloadTask.create(
        id: props.id,
        index: props.index,
        illust: props.illust!,
        originalUrl: props.originalUrl,
        url: props.url,
        filename: props.filename,
      );
      task.state = DownloadState.downloading;
      props.hostSendPort.send(task);
      await httpClient.get<Uint8List>(
        props.url,
        onReceiveProgress: (int count, int total) {
          task.progress = count / total;
          props.hostSendPort.send(task);
        },
      ).then((result) async {
        task.state = DownloadState.complete;
        props.hostSendPort.send(_DownloadComplete(result.data!, props.filename, props.id, props.index));
        props.hostSendPort.send(task);
      }).catchError((e, s) async {
        task.state = DownloadState.failed;
        props.hostSendPort.send(task);
        props.hostSendPort.send(_DownloadError());
      });
    } else {
      await httpClient
          .get<Uint8List>(
        props.url,
      )
          .then((result) async {
        props.hostSendPort.send(_DownloadComplete(result.data!, props.filename, props.id, props.index));
      }).catchError((e, s) async {
        props.hostSendPort.send(_DownloadError());
      });
    }
  }

  static Future<void> start({
    Illust? illust,
    required String url,
    int? id,
    required int index,
  }) async {
    final filename = url.substring(url.lastIndexOf('/') + 1);
    final imageUrl = Utils.replaceImageSource(url);

    if (await PlatformApi.imageIsExist(filename)) {
      PlatformApi.toast('图片已经存在');
      return;
    }

    final taskIndex = Get.find<DownloadManagerController>().tasks.indexWhere((task) => filename == task.filename);
    if (-1 != taskIndex && DownloadState.failed != Get.find<DownloadManagerController>().tasks[taskIndex].state) {
      PlatformApi.toast('下载任务已经存在');
      return;
    }

    PlatformApi.toast('下载开始');
    Isolate.spawn(
      _task,
      _DownloadStartProps(
        hostSendPort: _hostReceivePort.sendPort,
        id: id ?? _currentId,
        illust: illust,
        originalUrl: url,
        url: imageUrl,
        filename: filename,
        index: index,
      ),
      debugName: 'IsolateDebug',
    );
  }
}

class _DownloadStartProps {
  final SendPort hostSendPort;
  final int id;
  final Illust? illust;
  final String originalUrl;
  final String url;
  final String filename;
  final int index;

  _DownloadStartProps({
    required this.hostSendPort,
    required this.id,
    required this.illust,
    required this.originalUrl,
    required this.url,
    required this.filename,
    required this.index,
  });
}

class _DownloadComplete {
  final Uint8List imageBytes;
  final String filename;
  final int id;
  final int index;

  _DownloadComplete(this.imageBytes, this.filename, this.id, this.index);
}

class _DownloadError {}
