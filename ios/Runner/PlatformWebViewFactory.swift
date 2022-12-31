import Foundation
import Flutter

class PlatformWebViewFactory: NSObject, FlutterPlatformViewFactory & FlutterPlugin {
    private unowned let messenger: FlutterBinaryMessenger
    private unowned let registrar: FlutterPluginRegistrar

    static let pluginName: String = "xiaocao/platform/web_view"

    init(messenger: FlutterBinaryMessenger, registrar: FlutterPluginRegistrar) {
        self.messenger = messenger
        self.registrar = registrar
        super.init()
    }

    private var handler: Handler?

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func create(
            withFrame frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: Any?
    ) -> FlutterPlatformView {

        let channel = FlutterMethodChannel(name: "\(PlatformWebViewFactory.pluginName)\(viewId)", binaryMessenger: registrar.messenger(), codec: FlutterStandardMethodCodec.sharedInstance())

        registrar.addMethodCallDelegate(self, channel: channel)


        let view = PlatformWebView(messenger: messenger, withFrame: frame, arguments: args)
        handler = view.handle

        return view
    }

    public static func register(with registrar: FlutterPluginRegistrar) {

        let instance = PlatformWebViewFactory(messenger: registrar.messenger(), registrar: registrar)

        registrar.register(instance, withId: pluginName)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        handler?(call, result)
    }
}
