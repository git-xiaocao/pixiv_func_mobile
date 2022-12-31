package moe.xiaocao.pixiv.appwidget

import android.content.Context
import androidx.work.*
import moe.xiaocao.pixiv.appwidget.provider.RecommendAppWidget
import java.util.concurrent.TimeUnit

class AppWidgetWorker(val context: Context, workerParams: WorkerParameters) : Worker(context, workerParams) {
    override fun doWork(): Result {

        return try {
            if (updateWidget()) {
                Result.success()
            } else {
                Result.retry()
            }

        } catch (e: Exception) {
            //异常了不处理 等待下一次任务
            Result.success()
        } finally {
            //开启下一次任务
            enqueueUnique(context)
        }
    }

    private fun updateWidget(): Boolean {
        return RecommendAppWidget.update(context)
    }

    companion object {

        fun enqueueUnique(context: Context) {
            val worker = OneTimeWorkRequest.Builder(AppWidgetWorker::class.java)
                .setConstraints(
                    Constraints.Builder().also {
                        //网络已连接
                        it.setRequiredNetworkType(NetworkType.CONNECTED)
                    }.build()
                )
                .setInitialDelay(10, TimeUnit.MINUTES)
                .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, OneTimeWorkRequest.MIN_BACKOFF_MILLIS, TimeUnit.MILLISECONDS)
                .build()


            WorkManager.getInstance(context).enqueueUniqueWork("AppWidgetAutoRefresh", ExistingWorkPolicy.REPLACE, worker)
        }

        fun cancelUnique(context: Context) {
            WorkManager.getInstance(context).cancelUniqueWork("AppWidgetAutoRefresh")
        }
    }

}
