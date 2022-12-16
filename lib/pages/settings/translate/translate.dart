import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/app/services/translate_service.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class TranslateSettingsPage extends StatelessWidget {
  const TranslateSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: '翻译设置',
      child: ObxValue<RxInt>(
        (data) {
          final translates = Get.find<TranslateService>().translates;
          void updater(int value) {
            Get.find<SettingsService>().translateIndex = value;
            data.value = value;
          }

          return NoScrollBehaviorWidget(
            child: ListView(
              children: [
                for (int i = 0; i < translates.length; i++)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                    onTap: () => updater(i),
                    title: TextWidget(translates[i].name, fontSize: 18, isBold: true),
                    trailing: i == data.value
                        ? Icon(
                            Icons.check,
                            size: 25,
                            color: Get.theme.colorScheme.primary,
                          )
                        : null,
                  ),
              ],
            ),
          );
        },
        Get.find<SettingsService>().translateIndex.obs,
      ),
    );
  }
}
