package moe.xiaocao.pixiv

import android.os.Bundle

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import moe.xiaocao.pixiv.appwidget.AppWidgetWorker
import moe.xiaocao.pixiv.appwidget.provider.RecommendAppWidget
import moe.xiaocao.pixiv.platform.api.PlatformApiPlugin
import moe.xiaocao.pixiv.platform.webview.PlatformWebViewPlugin


class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //有AppWidget才启动定时任务
        if (RecommendAppWidget.getIds(context).isNotEmpty()) {
            AppWidgetWorker.enqueueUnique(context)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        flutterEngine.plugins.add(PlatformWebViewPlugin())
        flutterEngine.plugins.add(PlatformApiPlugin(context))

        super.configureFlutterEngine(flutterEngine)
    }

}
