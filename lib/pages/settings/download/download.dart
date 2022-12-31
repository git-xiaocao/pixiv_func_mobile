import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class DownloadSettingsPage extends StatelessWidget {
  const DownloadSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: I18n.downloadSettingsPageTitle.tr,
      child: Column(
        children: [
          ObxValue(
            (data) {
              void updater(double value) {
                data.value = value.toInt();
                Get.find<SettingsService>().maxDownloadCount = value.toInt();
              }

              return Column(
                children: [
                  TextWidget(I18n.maxDownloadTaskCount.trArgs(['${data.value.toInt()}'])),
                  Slider(
                    value: data.value.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: updater,
                  ),
                ],
              );
            },
            Get.find<SettingsService>().maxDownloadCount.obs,
          ),
          ListTile(
            title: TextWidget('保存目录: ${Get.find<SettingsService>()}'),
          ),
          ElevatedButton(
            onPressed: () async {
              final path = FilePicker.platform.getDirectoryPath(dialogTitle: '选择图片保存目录');
            },
            child: TextWidget('保存目录'),
          ),
        ],
      ),
    );
  }
}
