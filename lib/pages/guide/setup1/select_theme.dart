import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/login/login.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class GuideSelectThemePage extends StatelessWidget {
  const GuideSelectThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<int>>(
      (data) => ScaffoldWidget(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              TextWidget(I18n.selectFavoriteTheme.tr, fontSize: 24, isBold: true),
              const Spacer(flex: 1),
              CupertinoSwitchListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                onTap: () {
                  data.value = 0;
                  Get.find<SettingsService>().theme = 0;
                  Get.changeThemeMode(ThemeMode.dark);
                },
                title: TextWidget(I18n.dark.tr, fontSize: 18, isBold: true),
                value: 0 == data.value,
              ),
              const Divider(),
              CupertinoSwitchListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                onTap: () {
                  data.value = 1;
                  Get.find<SettingsService>().theme = 1;
                  Get.changeThemeMode(ThemeMode.light);
                },
                title: TextWidget(I18n.light.tr, fontSize: 18, isBold: true),
                value: 1 == data.value,
              ),
              const Divider(),
              CupertinoSwitchListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                onTap: () {
                  data.value = -1;
                  Get.find<SettingsService>().theme = -1;
                  Get.changeThemeMode(ThemeMode.system);
                },
                title: TextWidget(I18n.followSystem.tr, fontSize: 18, isBold: true),
                value: -1 == data.value,
              ),
              const Spacer(flex: 2),
              MaterialButton(
                elevation: 0,
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                minWidth: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextWidget(I18n.next.tr, fontSize: 18, color: Colors.white, isBold: true),
                ),
                onPressed: () {
                  Get.find<SettingsService>().guideInit = true;
                  Get.to(() => const LoginPage(isFirst: true));
                },
              ),
              const Spacer(flex: 1),
              TextWidget(I18n.laterChangeInSettings.tr, fontSize: 14),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
      Rx<int>(Get.find<SettingsService>().theme),
    );
  }
}
