package moe.xiaocao.pixiv.util

import java.util.zip.ZipEntry
import java.util.zip.ZipInputStream

fun ZipInputStream.forEachEntry(action: (entry: ZipEntry) -> Unit) {
    var zipEntry: ZipEntry?
    while (
        this.run {
            zipEntry = this.nextEntry
            null != zipEntry
        }
    ) {
        zipEntry?.let { action(it) }
    }
}