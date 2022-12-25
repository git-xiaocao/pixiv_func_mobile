import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/encrypt/encrypt.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/pages/about/about.dart';
import 'package:pixiv_func_mobile/pages/account/account.dart';
import 'package:pixiv_func_mobile/pages/block_tag/block_tag.dart';
import 'package:pixiv_func_mobile/pages/downloader/downloader.dart';
import 'package:pixiv_func_mobile/pages/history/history.dart';
import 'package:pixiv_func_mobile/pages/settings/browse/browse.dart';
import 'package:pixiv_func_mobile/pages/settings/language/language_settings.dart';
import 'package:pixiv_func_mobile/pages/settings/theme/theme_settings.dart';
import 'package:pixiv_func_mobile/pages/settings/translate/translate.dart';
import 'package:pixiv_func_mobile/pages/user/me.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  Widget buildItem({required VoidCallback onTap, required String title}) {
    return ListTile(
      onTap: onTap,
      title: TextWidget(title, fontSize: 16, isBold: true),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      emptyAppBar: true,
      child: NoScrollBehaviorWidget(
        child: ListView(
          children: [
            GestureDetector(
              onLongPress: () async {
                Utils.copyToClipboard(Encrypt.encode(jsonEncode(Get.find<AccountService>().current)));
                PlatformApi.toast(I18n.copiedToClipboardHint.tr);
              },
              child: InkWell(
                onTap: () => Get.to(() => const MePage()),
                child: Obx(
                  () {
                    if (Get.find<AccountService>().isEmpty) {
                      return const SizedBox();
                    }
                    final localUser = Get.find<AccountService>().accounts()[Get.find<AccountService>().currentIndex.value].localUser;
                    return Card(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                            child: SizedBox(
                              height: 85,
                              child: PixivAvatarWidget(
                                localUser.profileImageUrls.px170x170,
                                radius: 85,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localUser.name,
                                  style: const TextStyle(fontSize: 28),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  localUser.mailAddress,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const Divider(),
            buildItem(onTap: () => Get.to(() => const AccountPage()), title: I18n.accountPageTitle.tr),
            const Divider(),
            buildItem(onTap: () => Get.to(() => const ThemeSettingsPage()), title: I18n.themeSettingsPageTitle.tr),
            buildItem(onTap: () => Get.to(() => const LanguageSettingsPage()), title: I18n.languageSettingsPageTitle.tr),
            buildItem(onTap: () => Get.to(() => const TranslateSettingsPage()), title: I18n.translateSettingsPageTitle.tr),
            const Divider(),
            buildItem(onTap: () => Get.to(() => const BrowseSettingsPage()), title: I18n.browseSettingsPageTitle.tr),
            buildItem(onTap: () => Get.to(() => const HistoryPage()), title: I18n.historyPageTitle.tr),
            buildItem(onTap: () => Get.to(() => const BlockTagPage()), title: I18n.blockTagPageTitle.tr),
            const Divider(),
            buildItem(onTap: () => Get.to(() => const DownloaderPage()), title: I18n.downloaderPageTitle.tr),
            const Divider(),
            buildItem(onTap: () => Get.to(() => const AboutPage()), title: I18n.aboutPageTitle.tr),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
