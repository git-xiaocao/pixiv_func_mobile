package moe.xiaocao.pixiv.util

import android.annotation.SuppressLint
import android.content.SharedPreferences
import android.util.Base64
import java.io.*

private const val LIST_IDENTIFIER = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu"

fun SharedPreferences.getStringList(key: String): List<String> {
    return decodeList(getString(key, "")!!.substring(LIST_IDENTIFIER.length))
}

@SuppressLint("CommitPrefEdits")
fun SharedPreferences.Editor.setStringList(key: String, list: List<String>) {
    putString(key, LIST_IDENTIFIER + encodeList(list))
}

private fun decodeList(encodedList: String): List<String> {
    var stream: ObjectInputStream? = null
    return try {
        stream = ObjectInputStream(ByteArrayInputStream(Base64.decode(encodedList, 0)))
        (stream.readObject() as List<*>).filterIsInstance<String>()
    } catch (e: ClassNotFoundException) {
        throw IOException(e)
    } finally {
        stream?.close()
    }
}

private fun encodeList(list: List<String>): String? {
    var stream: ObjectOutputStream? = null
    return try {
        val byteStream = ByteArrayOutputStream()
        stream = ObjectOutputStream(byteStream)
        stream.writeObject(list)
        stream.flush()
        Base64.encodeToString(byteStream.toByteArray(), 0)
    } finally {
        stream?.close()
    }
}
