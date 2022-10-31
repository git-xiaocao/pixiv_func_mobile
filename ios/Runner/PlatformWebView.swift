import Foundation
import Flutter
import UIKit
import WebKit

typealias CallBackChannel = FlutterBasicMessageChannel

class PlatformWebView: FlutterPlatformView & NSObject {

    private let webView: WKWebView
    private unowned let messenger: FlutterBinaryMessenger

    private let resultChannel: CallBackChannel
    private let progressChannel: CallBackChannel
    private let argumentsOnCreated: Dictionary<String, Any?>
    private let useLocalReverseProxy: Bool

    func view() -> UIView {
        webView
    }

    init(messenger: FlutterBinaryMessenger, withFrame frame: CGRect, arguments args: Any?) {
        let conf = WKWebViewConfiguration()
        conf.preferences.minimumFontSize = 9.0
        self.messenger = messenger


        argumentsOnCreated = args as! Dictionary<String, Any?>
        useLocalReverseProxy = argumentsOnCreated["useLocalReverseProxy"] as! Bool


        webView = WKWebView(frame: .zero, configuration: conf)


        resultChannel = FlutterBasicMessageChannel(name: "\(PlatformWebViewFactory.pluginName)/result", binaryMessenger: messenger, codec: FlutterStandardMessageCodec.sharedInstance())
        progressChannel = FlutterBasicMessageChannel(name: "\(PlatformWebViewFactory.pluginName)/progress", binaryMessenger: messenger, codec: FlutterStandardMessageCodec.sharedInstance())

        super.init()


        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.customUserAgent = "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/100.0.4896.127 Safari/537.36"

    }

    deinit {

    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressChannel.sendMessage(Int(webView.estimatedProgress * 100))
        }
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = Method(rawValue: call.method) else {
            return result(FlutterMethodNotImplemented)
        }
        switch method {
        case .loadUrl:
            if let url = URL(string: (call.arguments as! [String: Any?])["url"] as! String) {

                webView.load(URLRequest(url: url))

            }
        case .reload:
            webView.reload()

        }
    }

    enum Method: String {
        case loadUrl = "loadUrl"
        case reload = "reload"
    }
}

extension PlatformWebView: WKNavigationDelegate {


    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        guard let serverTrust = challenge.protectionSpace.serverTrust else {

            completionHandler(.performDefaultHandling, nil)
            return
        }
        let credential = URLCredential(trust: serverTrust)

        completionHandler(.useCredential, credential)

    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        let url = request.url
        if "pixiv" == url?.scheme {

            if let host = url?.host, host.contains("account") {
                do {
                    webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in

                        resultChannel.sendMessage([
                            "type": "code",
                            "content": try url?.getQueryStringParameter(key: "code"),
                            "cookie": cookies["https://pixiv.net"]
                        ])
                    }

                } catch {

                    print(error)
                }
            }
        }
        decisionHandler(.allow)

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        resultChannel.sendMessage([
            "type": "pageFinished",
            "data": webView.url,
        ])
    }
}
