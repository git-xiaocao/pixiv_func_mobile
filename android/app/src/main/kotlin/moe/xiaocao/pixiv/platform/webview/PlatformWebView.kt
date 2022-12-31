package moe.xiaocao.pixiv.platform.webview

import PixivLocalReverseProxy.PixivLocalReverseProxy
import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.net.http.SslError
import android.util.Log
import android.view.View
import android.webkit.*
import androidx.webkit.ProxyConfig
import androidx.webkit.ProxyController
import androidx.webkit.WebViewFeature
import io.flutter.plugin.common.*
import io.flutter.plugin.platform.PlatformView
import kotlin.collections.HashMap

@SuppressLint("SetJavaScriptEnabled")
class PlatformWebView(
    context: Context,
    binaryMessenger: BinaryMessenger,
    viewId: Int,
    arguments: Any?
) : PlatformView, MethodChannel.MethodCallHandler, BasicMessageChannel.MessageHandler<Any> {

    private val webView = WebView(context)

    private val useLocalReverseProxy: Boolean =
        (arguments as Map<*, *>)["useLocalReverseProxy"] as Boolean

    private val enableLog: Boolean =
        (arguments as Map<*, *>)["enableLog"] as Boolean

    private val messageChannel: BasicMessageChannel<Any> =
        BasicMessageChannel(
            binaryMessenger,
            "${PlatformWebViewPlugin.pluginName}/result",
            StandardMessageCodec()
        )
    private val progressMessageChannel: BasicMessageChannel<Any> =
        BasicMessageChannel(
            binaryMessenger,
            "${PlatformWebViewPlugin.pluginName}/progress",
            StandardMessageCodec()
        )


    override fun onFlutterViewAttached(flutterView: View) {

        if (useLocalReverseProxy) {
            if (WebViewFeature.isFeatureSupported(WebViewFeature.PROXY_OVERRIDE)) {
                PixivLocalReverseProxy.startServer("12345", enableLog)
                val proxyConfig: ProxyConfig = ProxyConfig.Builder()
                    .addProxyRule("127.0.0.1:12345")
                    .addDirect()
                    .build()
                ProxyController.getInstance().setProxyOverride(
                    proxyConfig,
                    { command -> command?.run() },
                ) {
                    Log.i("PlatformWebView", "Set Reverse Proxy")
                }
            }
        }
        super.onFlutterViewAttached(flutterView)
    }

    override fun dispose() {
        if (useLocalReverseProxy) {
            if (WebViewFeature.isFeatureSupported(WebViewFeature.PROXY_OVERRIDE)) {
                ProxyController.getInstance().clearProxyOverride(
                    { command -> command?.run() },
                ) {
                    Log.i("PlatformWebView", "Clear Reverse Proxy")
                }
                PixivLocalReverseProxy.stopServer()
            }

        }
        super.onFlutterViewDetached()
        webView.destroy()
    }

    init {
        webView.settings.apply {
            javaScriptEnabled = true
            javaScriptCanOpenWindowsAutomatically = true
            //Google授权和Facebook授权不允许WebView登录
            userAgentString = "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/100.0.4896.127 Safari/537.36"
        }

        webView.webViewClient = object : WebViewClient() {

            @SuppressLint("WebViewClientOnReceivedSslError")
            override fun onReceivedSslError(
                view: WebView?,
                handler: SslErrorHandler?,
                error: SslError?
            ) {
                handler?.proceed()
            }

            override fun shouldOverrideUrlLoading(
                view: WebView?,
                request: WebResourceRequest?
            ): Boolean {
                request?.let {
                    val uri = it.url

                    if ("pixiv" == uri.scheme) {

                        val host = uri.host
                        if (null != host && host.contains("account")) {

                            try {
                                messageChannel.send(
                                    mapOf(
                                        "type" to "account",
                                        "data" to uri.toString(),
                                        "cookie" to CookieManager.getInstance().getCookie("https://pixiv.net"),
                                    )
                                )

                            } catch (e: Exception) {
                            }
                        }
                        return true
                    }


                }
                return super.shouldOverrideUrlLoading(view, request)
            }

            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                view?.apply {
                    messageChannel.send(
                        mapOf(
                            "type" to "pageStarted",
                            "data" to url
                        )
                    )
                }
                super.onPageStarted(view, url, favicon)
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                view?.apply {
                    messageChannel.send(
                        mapOf(
                            "type" to "pageFinished",
                            "data" to url
                        )
                    )
                }
                super.onPageFinished(view, url)
            }
        }

        webView.webChromeClient = object : WebChromeClient() {
            override fun onProgressChanged(view: WebView?, newProgress: Int) {
                progressMessageChannel.send(newProgress)
                super.onProgressChanged(view, newProgress)
            }

        }

        MethodChannel(
            binaryMessenger,
            "${PlatformWebViewPlugin.pluginName}$viewId"
        ).setMethodCallHandler(this)
    }

    override fun getView(): View {
        return webView
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            PlatformWebViewPlugin.methodLoadUrl -> {
                val headers: MutableMap<String, String> = HashMap()

                headers["Accept-Language"] = "zh-CN"

                webView.loadUrl(call.argument<String>("url")!!, headers)
            }
            PlatformWebViewPlugin.methodEvaluateJavascript -> {
                webView.evaluateJavascript(call.argument<String>("script")!!) {
                    result.success(it)
                }
            }
            PlatformWebViewPlugin.methodReload -> {
                webView.reload()
            }
            PlatformWebViewPlugin.methodCanGoBack -> {
                result.success(webView.canGoBack())
            }
            PlatformWebViewPlugin.methodGoBack -> {
                webView.goBack()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onMessage(message: Any?, reply: BasicMessageChannel.Reply<Any>) {

    }
}
