package moe.xiaocao.pixiv.platform.webview


import io.flutter.embedding.engine.plugins.FlutterPlugin

class PlatformWebViewPlugin : FlutterPlugin {

    companion object {
        const val pluginName = "xiaocao/platform/web_view"

        const val methodLoadUrl = "loadUrl"
        const val methodEvaluateJavascript = "evaluateJavascript"
        const val methodReload = "reload"
        const val methodCanGoBack = "canGoBack"
        const val methodGoBack = "goBack"
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        binding.platformViewRegistry.registerViewFactory(
            pluginName,
            PlatformWebViewFactory(binding.binaryMessenger)
        )

    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

    }
}
