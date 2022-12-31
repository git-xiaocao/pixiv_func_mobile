package moe.xiaocao.pixiv.util

import android.os.Handler
import android.os.Looper
import kotlin.concurrent.thread

fun <T> newThreadFunc(func: () -> T, resultCallback: (data: T) -> Unit) {
    thread {
        val result = func()
        Handler(Looper.getMainLooper()).post {
            resultCallback(result)
        }
    }
}
