import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/services/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class ImageSourceSettingsPage extends StatelessWidget {
  const ImageSourceSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController customImageSourceInput = TextEditingController();

    const List<MapEntry<String, String>> items = [
      MapEntry('IP(210.140.92.148)', '210.140.92.148'),
      MapEntry('Original(i.pximg.net)', 'i.pximg.net'),
    ];
    return ScaffoldWidget(
      title: I18n.imageSourceSettingsPageTitle.tr,
      child: ObxValue<Rx<String>>(
        (Rx<String> data) {
          void updater(String? value) {
            if (null != value) {
              data.value = value;
              Get.find<SettingsService>().imageSource = value;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in items)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                  onTap: () => updater(item.value),
                  title: TextWidget(item.key, fontSize: 18, isBold: true),
                  trailing: data.value == item.value ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 20) : null,
                ),
              InkWell(
                onTap: () => updater(customImageSourceInput.text),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: customImageSourceInput,
                          decoration: InputDecoration(
                            constraints: const BoxConstraints(maxHeight: 40),
                            hintText: I18n.useCustomImageSource.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          ),
                          onChanged: updater,
                        ),
                      ),
                      const Spacer(flex: 1),
                      IgnorePointer(
                        child: CupertinoSwitch(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: data.value == customImageSourceInput.text,
                          onChanged: (value) => updater(value ? customImageSourceInput.text : null),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
        Get.find<SettingsService>().imageSource.obs,
      ),
    );
  }
}
