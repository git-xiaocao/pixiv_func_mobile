package moe.xiaocao.pixiv.util

import android.content.ContentValues
import android.content.Context
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import java.io.File


fun Context.saveImage(imageBytes: ByteArray, filename: String): Boolean {

    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {

        val saveDirectory = File(
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES),
            "PixivFunc"
        )

        val imageFile = File("${saveDirectory.absolutePath}/$filename")

        val parent = imageFile.parentFile ?: return false

        //目录不存在就创建
        if (!parent.exists() && !parent.mkdirs()) {
            return false
        }

        imageFile.outputStream().use {
            it.write(imageBytes)
        }
        MediaScannerConnection.scanFile(
            this, arrayOf(imageFile.absolutePath), arrayOf(
                MimeTypeMap.getSingleton().getMimeTypeFromExtension(
                    MimeTypeMap.getFileExtensionFromUrl(filename)
                )
            )
        ) { _, _ ->

        }
        return true
    }

    val values = ContentValues()
    //文件名
    values.put(MediaStore.MediaColumns.DISPLAY_NAME, filename)



    values.put(
        MediaStore.MediaColumns.MIME_TYPE,
        MimeTypeMap.getSingleton()
            .getMimeTypeFromExtension(MimeTypeMap.getFileExtensionFromUrl(filename))
    )

    //相册目录
    values.put(
        MediaStore.MediaColumns.RELATIVE_PATH,
        "${Environment.DIRECTORY_PICTURES}/PixivFunc"
    )

    var uri: Uri? = null
    return try {
        uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
        contentResolver.openOutputStream(uri!!)?.use {
            it.write(imageBytes)
        }
        true
    } catch (e: Exception) {
        uri?.let { contentResolver.delete(it, null, null) }
        false
    }

}


fun Context.imageIsExist(filename: String): Boolean {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
        val saveDirectory =
            File(
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES),
                "PixivFunc"
            )

        return saveDirectory.exists() && File("${saveDirectory.absolutePath}/$filename").exists()
    }

    val where =
        "${MediaStore.Images.Media.RELATIVE_PATH} LIKE ? AND ${MediaStore.Images.Media.DISPLAY_NAME} = ?"

    val args = arrayOf(
        "%${Environment.DIRECTORY_PICTURES}/${"PixivFunc"}%",
        filename,
    )

    contentResolver.query(
        MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
        arrayOf(MediaStore.Images.Media._ID),
        where,
        args,
        //不排序
        null
    )?.use { cursor ->
        if (cursor.moveToNext()) {
            return true
        }
    }

    return false
}