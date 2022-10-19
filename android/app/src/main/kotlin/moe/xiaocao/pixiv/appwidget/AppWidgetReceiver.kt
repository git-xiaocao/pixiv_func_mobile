package moe.xiaocao.pixiv.appwidget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.Toast
import moe.xiaocao.pixiv.appwidget.provider.RecommendAppWidget
import moe.xiaocao.pixiv.appwidget.provider.RefreshAppWidget

class AppWidgetReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            RecommendAppWidget.click -> {
                //url scheme 可以在APP关闭的情况下也能打开APP
                context.startActivity(
                    Intent(Intent.ACTION_VIEW, Uri.parse("pixivfunc://illusts/${intent.getStringExtra("id")}")).also {
                        it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    },
                )
            }
            RefreshAppWidget.click -> {
                if (RecommendAppWidget.update(context)) {
                    Toast.makeText(context, "已刷新", Toast.LENGTH_LONG).show()
                }
            }
        }

    }


}
