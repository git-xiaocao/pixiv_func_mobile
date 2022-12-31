import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controller.dart';

class PlatformWebView extends StatelessWidget {
  final void Function(Map message) onMessageHandler;
  final void Function(PlatformWebViewController controller) onCreated;
  final bool useLocalReverseProxy;
  final String tag;

  const PlatformWebView({
    Key? key,
    required this.onMessageHandler,
    required this.onCreated,
    required this.useLocalReverseProxy,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PlatformWebViewController(onMessageHandler, onCreated), tag: tag);
    return GetBuilder<PlatformWebViewController>(
      tag: tag,
      builder: (controller) => WillPopScope(
          child: Column(
            children: [
              Visibility(
                visible: controller.progress < 1.0,
                child: LinearProgressIndicator(value: controller.progress),
              ),
              Expanded(
                child: AndroidView(
                  viewType: PlatformWebViewController.pluginName,
                  creationParams: {
                    'useLocalReverseProxy': useLocalReverseProxy,
                    'enableLog': true,
                  },
                  creationParamsCodec: const StandardMessageCodec(),
                  onPlatformViewCreated: controller.onViewCreated,
                ),
              )
            ],
          ),
          onWillPop: () async {
            if (await controller.canGoBack()) {
              controller.goBack();
              return false;
            } else {
              return true;
            }
          }),
    );
  }
}
