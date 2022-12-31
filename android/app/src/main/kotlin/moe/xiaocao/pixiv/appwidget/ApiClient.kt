package moe.xiaocao.pixiv.appwidget

import android.annotation.SuppressLint
import android.content.Context
import android.content.SharedPreferences

import kotlinx.serialization.Serializable
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import api.moe.xiaocao.IllustType
import api.moe.xiaocao.PixivApi
import api.moe.xiaocao.model.Illust
import moe.xiaocao.pixiv.util.getStringList
import moe.xiaocao.pixiv.util.setStringList

import api.moe.xiaocao.vo.UserAccount


class ApiClient(val context: Context) {
    private val json = Json {
        //宽松模式
        isLenient = true
        //指定是否应编码 Kotlin 属性的默认值
        encodeDefaults = true
        //是否应忽略输入 JSON 中遇到的未知属性
        ignoreUnknownKeys = true
        //启用将不正确的 JSON 值强制为默认属性值
        coerceInputValues = true
        //指定 Json 实例是否使用 JsonNames 注释。
        useAlternativeNames = false
    }
    private val sharedPreferences: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
    suspend fun refreshRecommend(): List<Illust>? {

        val userAccount = getUserAccount()
        //如果没获取到就是没登录
        return if (userAccount != null) {
            PixivApi(userAccount) {
                updateUserAccount(it)
            }.getRecommendedIllustPage(IllustType.ILLUST).illusts
        } else {
            null
        }

    }


    private fun getUserAccount(): UserAccount? {
        val index = sharedPreferences.getLong("flutter.account_index", -1).toInt()

        return if (-1 == index) {
            null
        } else {
            val accounts = sharedPreferences.getStringList("flutter.accounts")
            if (accounts.isEmpty()) {
                null
            } else {
                json.decodeFromString<FlutterAccount>(accounts[index]).userAccount
            }
        }

    }

    @SuppressLint("CommitPrefEdits")
    private fun updateUserAccount(userAccount: UserAccount) {
        val index = sharedPreferences.getLong("flutter.account_index", -1).toInt()

        if (-1 != index) {
            val accounts = sharedPreferences.getStringList("flutter.accounts")
            if (accounts.isEmpty()) {
                val list = arrayListOf<String>()
                accounts.toList().forEach {
                    list.add(it)
                }

                list[index] = json.encodeToString(json.decodeFromString<FlutterAccount>(list[index]).also {
                    it.userAccount = userAccount
                })

                sharedPreferences.edit().setStringList("flutter.accounts", list)

            }
        }

    }

    fun toCurrentImageSource(url: String): String {
        return url.replace("i.pximg.net", sharedPreferences.getString("imageSource", null) ?: "210.140.92.148")
    }

    @Serializable
    data class FlutterAccount(
        val cookie: String,
        var userAccount: UserAccount,
    )
}
