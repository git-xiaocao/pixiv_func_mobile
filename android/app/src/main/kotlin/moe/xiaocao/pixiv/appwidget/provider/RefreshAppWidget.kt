package moe.xiaocao.pixiv.appwidget.provider

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import moe.xiaocao.pixiv.R
import moe.xiaocao.pixiv.appwidget.AppWidgetReceiver


class RefreshAppWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {

    }

    override fun onDisabled(context: Context) {

    }


    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {


        val views = RemoteViews(context.packageName, R.layout.refresh_app_widget)

        val intent = Intent(context, AppWidgetReceiver::class.java)
        intent.action = click

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            appWidgetId,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )

        views.setViewPadding(R.id.refresh_appwidget_image, 10, 10, 10, 10)
        views.setOnClickPendingIntent(R.id.refresh_appwidget_image, pendingIntent)


        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    companion object {
        const val click = "click_refresh"
    }
}

