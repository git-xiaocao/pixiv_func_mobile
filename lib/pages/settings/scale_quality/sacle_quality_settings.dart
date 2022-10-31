import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class ScaleQualitySettingsPage extends StatelessWidget {
  const ScaleQualitySettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, bool>> items = [
      MapEntry(I18n.largeImage.tr, false),
      MapEntry(I18n.originalImage.tr, true),
    ];
    return ScaffoldWidget(
      title: I18n.scaleQualitySettingsPageTitle.tr,
      child: ObxValue(
        (Rx<bool> data) {
          void updater(bool? value) {
            if (null != value) {
              data.value = value;
              Get.find<SettingsService>().scaleQuality = value;
            }
          }

          return Column(
            children: [
              for (final item in items)
                CupertinoSwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                  onTap: () => updater(item.value),
                  title: TextWidget(item.key, fontSize: 18, isBold: true),
                  value: data.value == item.value,
                ),
            ],
          );
        },
        Get.find<SettingsService>().scaleQuality.obs,
      ),
    );
  }
}
