package moe.xiaocao.pixiv.platform.api

import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.widget.Toast
import com.waynejo.androidndkgif.GifEncoder
import moe.xiaocao.pixiv.util.forEachEntry
import moe.xiaocao.pixiv.util.imageIsExist
import moe.xiaocao.pixiv.util.saveImage
import java.io.ByteArrayInputStream
import java.io.File
import java.util.zip.ZipInputStream

class PlatformApi(private val context: Context) {

    val pluginName = "xiaocao/platform/api"

    fun saveImage(imageBytes: ByteArray, filename: String): Boolean? {
        return context.saveImage(imageBytes, filename)
    }

    fun saveGifImage(id: Int, images: List<ByteArray>, delays: List<Int>): Boolean {
        var init = false
        var index = 0

        val gifFile = File(context.externalCacheDir, "$id.gif")

        val gifEncoder = GifEncoder()

        images.forEach { bytes ->
            val bitmap =
                BitmapFactory.decodeByteArray(
                    bytes,
                    0,
                    bytes.size,
                )
            if (!init) {
                init = true
                gifEncoder.init(
                    bitmap.width,
                    bitmap.height,
                    gifFile.absolutePath,
                    GifEncoder.EncodingType.ENCODING_TYPE_FAST
                )
            }
            gifEncoder.encodeFrame(bitmap, delays[index++])
        }
        gifEncoder.close()

        gifFile.also {
            saveImage(it.readBytes(), it.name)
        }.delete()
        return true
    }

    fun unZipGif(zipBytes: ByteArray): List<ByteArray> {
        val list: ArrayList<ByteArray> = arrayListOf()
        ByteArrayInputStream(zipBytes).use { byteArrayInputStream ->
            ZipInputStream(byteArrayInputStream).use { zipInputStream ->
                zipInputStream.forEachEntry {
                    list.add(zipInputStream.readBytes())
                }
            }
        }
        return list
    }

    fun imageIsExist(filename: String): Boolean {
        return context.imageIsExist(filename)
    }

    fun toast(content: String, isLong: Boolean) {
        Toast.makeText(
            context,
            content,
            if (isLong)
                Toast.LENGTH_LONG
            else
                Toast.LENGTH_SHORT,
        ).show()
    }

    fun getBuildVersion(): Int {
        return Build.VERSION.SDK_INT
    }

    fun getAppVersionName(): String {
        return context.packageManager.getPackageInfo(
            context.packageName,
            0
        ).versionName
    }

    fun getAppVersionCode(): Int {
        return context.packageManager.getPackageInfo(
            context.packageName,
            0
        ).versionCode
    }

    fun urlLaunch(url: String): Boolean {
        return try {
            context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
            true
        } catch (e: Exception) {
            false
        }
    }



    enum class Method(val value: String) {
        SAVE_IMAGE("saveImage"),
        SAVE_GIF_IMAGE("saveGifImage"),
        UN_ZIP_GIF("unZipGif"),
        IMAGE_IS_EXIST("imageIsExist"),
        TOAST("toast"),
        GET_BUILD_VERSION("getBuildVersion"),
        GET_APP_VERSION_NAME("getAppVersionName"),
        GET_APP_VERSION_CODE("getAppVersionCode"),
        URL_LAUNCH("urlLaunch"),
    }
}
