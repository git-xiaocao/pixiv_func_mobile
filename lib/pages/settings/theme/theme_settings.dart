import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, int>> items = [
      MapEntry(I18n.dark.tr, 0),
      MapEntry(I18n.light.tr, 1),
      MapEntry(I18n.followSystem.tr, -1),
    ];
    return ScaffoldWidget(
      title: I18n.themeSettingsPageTitle.tr,
      child: ObxValue(
        (Rx<int> data) {
          void updater(int? value) {
            if (null != value) {
              Get.changeThemeMode(
                -1 == value
                    ? ThemeMode.system
                    : value == 0
                        ? ThemeMode.dark
                        : ThemeMode.light,
              );
              data.value = value;
              Get.find<SettingsService>().theme = value;
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
        Get.find<SettingsService>().theme.obs,
      ),
    );
  }
}
