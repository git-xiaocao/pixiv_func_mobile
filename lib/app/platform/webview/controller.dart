import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PlatformWebViewController extends GetxController {
  static const pluginName = 'xiaocao/platform/web_view';

  static const _methodLoadUrl = 'loadUrl';
  static const _methodEvaluateJavascript = 'evaluateJavascript';
  static const _methodReload = 'reload';
  static const _methodCanGoBack = 'canGoBack';
  static const _methodGoBack = 'goBack';

  final void Function(Map message)? _onMessageHandler;

  final void Function(PlatformWebViewController controller) _onCreated;

  PlatformWebViewController(
    void Function(Map message) onMessageHandler,
    void Function(PlatformWebViewController controller) onCreated,
  )   : _onMessageHandler = onMessageHandler,
        _onCreated = onCreated;

  late final MethodChannel _channel;

  double _progress = 0;

  double get progress => _progress;

  Future<void> loadUrl(String url) {
    return _channel.invokeMethod(_methodLoadUrl, {'url': url});
  }

  Future<String> evaluateJavascript(String script) {
    return _channel.invokeMethod<String>(_methodEvaluateJavascript, {'script': script}).then((value) => value!);
  }

  Future<void> reload() {
    return _channel.invokeMethod(_methodReload);
  }

  Future<bool> canGoBack() {
    return _channel.invokeMethod(_methodCanGoBack).then((value) => value == true);
  }

  Future<void> goBack() {
    return _channel.invokeMethod(_methodGoBack);
  }

  void onViewCreated(int viewId) {
    _channel = MethodChannel('$pluginName$viewId');
    _onCreated(this);
  }

  @override
  void onReady() {
    const BasicMessageChannel(
      '$pluginName/result',
      StandardMessageCodec(),
    ).setMessageHandler(
      (dynamic message) async {
        _onMessageHandler?.call(message as Map);
        return null;
      },
    );

    const BasicMessageChannel(
      '$pluginName/progress',
      StandardMessageCodec(),
    ).setMessageHandler(
      (dynamic message) async {
        if (message is int) {
          _progress = message / 100;
          update();
        }
        return null;
      },
    );
    super.onReady();
  }
}
