import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/guide/setup1/select_theme.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class GuideSelectLanguagePage extends StatelessWidget {
  const GuideSelectLanguagePage({Key? key}) : super(key: key);

  static const defaultLocale = Locale('zh', 'CN');

  @override
  Widget build(BuildContext context) {
    const List<MapEntry<String, String>> items = [
      MapEntry('简体中文', 'zh_CN'),
      MapEntry('English', 'en_US'),
      MapEntry('日本語', 'ja_JP'),
      MapEntry('Русский', 'ru_RU'),
    ];
    return ObxValue<Rx<String?>>(
      (data) {
        void updater(String? value) {
          if (null != value) {
            final list = value.split('_');
            Get.updateLocale(Locale(list.first, list.last));
            data.value = value;
            Get.find<SettingsService>().language = value;
          }
        }

        return ScaffoldWidget(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                const TextWidget('选择您的语言', fontSize: 24, isBold: true, locale: defaultLocale),
                const TextWidget('Select your language', fontSize: 24, isBold: true, locale: defaultLocale),
                const TextWidget('言語を選択', fontSize: 24, isBold: true, locale: defaultLocale),
                const TextWidget('Выберите свой язык', fontSize: 24, isBold: true, locale: defaultLocale),
                const Spacer(flex: 1),
                for (final item in items)
                  Column(
                    children: [
                      CupertinoSwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                        onTap: () => updater(item.value),
                        title: TextWidget(item.key, fontSize: 18, isBold: true, locale: defaultLocale),
                        value: data.value == item.value,
                      ),
                      const Divider(),
                    ],
                  ),
                const Spacer(flex: 2),
                MaterialButton(
                  elevation: 0,
                  color: null == data.value ? const Color(0xFFE9E9EA) : const Color(0xFFFF6289),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  minWidth: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextWidget(I18n.next.tr, fontSize: 18, color: Colors.white, isBold: true, locale: defaultLocale, forceStrutHeight: true),
                  ),
                  onPressed: () => Get.to(() => const GuideSelectThemePage()),
                ),
                const Spacer(flex: 1),
                const TextWidget('稍后您可以在设置中进行相应变更', fontSize: 14, locale: defaultLocale),
                const TextWidget('You can change the settings later', fontSize: 14, locale: defaultLocale),
                const TextWidget('後で設定を変更できます', fontSize: 14, locale: defaultLocale),
                const TextWidget('Вы можете изменить его позже в настройках', fontSize: 14, locale: defaultLocale),
                const Spacer(flex: 1),
              ],
            ),
          ),
        );
      },
      Get.find<SettingsService>().language.obs,
    );
  }
}
