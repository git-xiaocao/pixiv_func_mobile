import UIKit
import Flutter
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

//        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
//            GeneratedPluginRegistrant.register(with: registry)
//        }
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        PixivApiPlugin.register(with: registrar(forPlugin: "PixivApiPlugin")!, window: window)

        PlatformWebViewFactory.register(with: registrar(forPlugin: "PlatformWebViewPlugin")!)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

}
