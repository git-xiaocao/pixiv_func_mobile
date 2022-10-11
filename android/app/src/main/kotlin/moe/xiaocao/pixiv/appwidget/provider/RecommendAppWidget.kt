package moe.xiaocao.pixiv.appwidget.provider

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.net.Uri
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.CenterCrop
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import com.bumptech.glide.request.target.AppWidgetTarget
import com.bumptech.glide.request.transition.Transition
import kotlinx.coroutines.runBlocking
import kotlinx.serialization.Serializable
import moe.xiaocao.pixiv.R
import moe.xiaocao.pixiv.appwidget.ApiClient
import moe.xiaocao.pixiv.appwidget.AppWidgetReceiver
import moe.xiaocao.pixiv.appwidget.AppWidgetWorker

class RecommendAppWidget : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {

        update(context, appWidgetManager, appWidgetIds)
        AppWidgetWorker.enqueueUnique(context)
    }


    override fun onEnabled(context: Context) {

    }

    override fun onDisabled(context: Context) {
        //取消自动刷新任务
        AppWidgetWorker.cancelUnique(context)
    }

    @Serializable
    data class IllustInfo(
        val id: Int,
        val url: String,
    )


    companion object {
        const val click = "click_illust"
        private val list: ArrayList<IllustInfo> = arrayListOf()

        fun update(context: Context): Boolean {
            return update(context, AppWidgetManager.getInstance(context), getIds(context))
        }

        fun update(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray): Boolean {
            Log.d("AppWidget", "update:${appWidgetIds.size},list.size < appWidgetIds.size:${list.size < appWidgetIds.size}")
            return runBlocking {
                val apiClient = ApiClient(context)
                for (i in appWidgetIds.indices) {
                    if (list.isEmpty()) {
                        try {
                            apiClient.refreshRecommend()?.let {
                                list.addAll(
                                    it.map { illust ->
                                        IllustInfo(
                                            id = illust.id,
                                            url = apiClient.toCurrentImageSource(illust.imageUrls.squareMedium),
                                        )
                                    }
                                )
                            }
                        } catch (e: Exception) {
                            //pixiv api异常了
                            return@runBlocking false
                        }
                    }
                    updateAppWidget(context, appWidgetManager, appWidgetIds[i], list.last())
                    list.removeLast()
                }
                true
            }
        }

        fun getIds(context: Context): IntArray {
            return AppWidgetManager.getInstance(context).getAppWidgetIds(ComponentName(context, RecommendAppWidget::class.java))
        }

        internal fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            illustInfo: IllustInfo,
            retryCount: Int = 0,
        ) {

            val views = RemoteViews(context.packageName, R.layout.recommend_app_widget)


            val appWidgetTarget = object : AppWidgetTarget(context, R.id.recommend_appwidget_image, views, appWidgetId) {
                override fun onLoadStarted(placeholder: Drawable?) {
                    views.setViewVisibility(R.id.appwidget_progress, View.VISIBLE)
                    views.setViewVisibility(R.id.recommend_appwidget_image, View.GONE)
                }

                override fun onLoadFailed(errorDrawable: Drawable?) {
                    if (retryCount < 3)
                        updateAppWidget(context, appWidgetManager, appWidgetId, illustInfo, retryCount + 1)
                    else {
                        views.setImageViewResource(R.id.recommend_appwidget_image, R.drawable.ic_launcher_foreground)
                        views.setViewVisibility(R.id.recommend_appwidget_image, View.VISIBLE)
                        views.setViewVisibility(R.id.appwidget_progress, View.GONE)
                    }
                }

                override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                    views.setViewVisibility(R.id.appwidget_progress, View.GONE)
                    views.setViewVisibility(R.id.recommend_appwidget_image, View.VISIBLE)

                    val intent = Intent(context, AppWidgetReceiver::class.java)
                    intent.action = click
                    intent.putExtra("id", illustInfo.id.toString())

                    val pendingIntent = PendingIntent.getBroadcast(
                        context,
                        illustInfo.id,
                        intent,
                        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
                    )

                    views.setOnClickPendingIntent(R.id.recommend_appwidget_image, pendingIntent)

                    super.onResourceReady(resource, transition)
                }
            }


            Glide.with(context).asBitmap().load(Uri.parse(illustInfo.url)).placeholder(R.drawable.ic_launcher_foreground)
                .error(R.drawable.ic_launcher_foreground)
                .transform(CenterCrop(), RoundedCorners(15)).override(600).into(appWidgetTarget)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
