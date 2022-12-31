import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';
import 'expansion/language_expansion.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({Key? key}) : super(key: key);

  static const defaultLocale = Locale('zh', 'CN');

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, String>> items = [
      const MapEntry('简体中文', 'zh_CN'),
      const MapEntry('English', 'en_US'),
      const MapEntry('日本語', 'ja_JP'),
      const MapEntry('Русский', 'ru_RU'),
    ];
    Get.put(LanguageController());
    return GetBuilder<LanguageController>(
      builder: (controller) => ScaffoldWidget(
        title: I18n.languageSettingsPageTitle.tr,
        child: ListView(
          children: [
            for (final item in items)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                onTap: () => controller.languageOnChange(item.value),
                title: TextWidget(item.key, fontSize: 18, isBold: true, locale: defaultLocale),
                trailing: controller.language == item.value
                    ? Icon(
                        Icons.check,
                        size: 25,
                        color: Get.theme.colorScheme.primary,
                      )
                    : null,
              ),
            const Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
              onTap: () => Get.to(const LanguageExpansionPage()),
              title: TextWidget(I18n.languageExpansion.tr, fontSize: 18, isBold: true, locale: defaultLocale),
            )
          ],
        ),
      ),
    );
  }
}
