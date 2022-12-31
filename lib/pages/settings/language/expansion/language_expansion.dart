import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n_translations.dart';
import 'package:pixiv_func_mobile/pages/settings/language/controller.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class LanguageExpansionPage extends StatelessWidget {
  const LanguageExpansionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (controller) => ScaffoldWidget(
        title: I18n.languageExpansion.tr,
        child: ListView(
          children: [
            ListTile(
              onTap: () => controller.clearExpansion(),
              title: TextWidget(I18n.clearLanguageExpansion.tr),
            ),
            ListTile(
              onTap: () => controller.getExpansionFromGithub(),
              title: TextWidget(I18n.loadFromGitHub.tr),
            ),
            const Divider(),
            for (final item in I18nTranslations.expansions)
              ListTile(
                onTap: () => controller.languageOnChange(item.locale),
                leading: ClipOval(
                  child: ExtendedImage.network(
                    'https://raw.githubusercontent.com/git-xiaocao/pixiv_func_i18n_expansion/main/${item.avatar}',
                    width: 45,
                    height: 45,
                  ),
                ),
                title: TextWidget('${item.title}(${item.locale})', fontSize: 16),
                subtitle: TextWidget('${item.github}(${item.author})'),
                trailing: controller.language == item.locale
                    ? Icon(
                        Icons.check,
                        size: 25,
                        color: Get.theme.colorScheme.primary,
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
