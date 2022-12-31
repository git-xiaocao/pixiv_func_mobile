import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/downloader/downloader.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/models/download_task.dart';
import 'package:pixiv_func_mobile/pages/illust/illust.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class DownloaderPage extends StatelessWidget {
  const DownloaderPage({Key? key}) : super(key: key);

  Widget buildItem(BuildContext context, DownloadTask task) {
    final Widget trailing;

    switch (task.state) {
      case DownloadState.idle:
        trailing = Container();
        break;
      case DownloadState.downloading:
        trailing = const CupertinoActivityIndicator();
        break;
      case DownloadState.failed:
        trailing = IconButton(
          splashRadius: 20,
          onPressed: () => Get.find<Downloader>().start(
            illust: task.illust,
            url: task.originalUrl,
            index: task.index,
            onComplete: null,
          ),
          icon: const Icon(Icons.refresh_outlined),
        );
        break;
      case DownloadState.complete:
        trailing = const Icon(Icons.file_download_done);
        break;
    }

    return Card(
      child: ListTile(
        onTap: () => Get.to(() => IllustPage(illust: task.illust)),
        title: TextWidget(task.illust.title, overflow: TextOverflow.ellipsis),
        subtitle: DownloadState.failed != task.state ? LinearProgressIndicator(value: task.progress) : const TextWidget('下载失败'),
        trailing: SizedBox(
          width: 48,
          child: trailing,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: I18n.downloaderPageTitle.tr,
      child: GetBuilder<Downloader>(
        builder: (controller) {
          return ListView(
            children: [for (final task in controller.tasks) buildItem(context, task)],
          );
        },
      ),
    );
  }
}
