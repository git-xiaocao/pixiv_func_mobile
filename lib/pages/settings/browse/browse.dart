import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class BrowseSettingsPage extends StatelessWidget {
  const BrowseSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<MapEntry<String, String>> imageSourceItems = [
      MapEntry('IP(210.140.92.148)', '210.140.92.148'),
      MapEntry('Original(i.pximg.net)', 'i.pximg.net'),
      MapEntry('MirrorImage(i.pixiv.re)', 'i.pixiv.re'),
    ];

    final settingsService = Get.find<SettingsService>();

    final TextEditingController customImageSourceInput = TextEditingController(
        text: imageSourceItems.any((item) => item.value == settingsService.imageSource) ? '' : settingsService.imageSource);

    return ScaffoldWidget(
      title: I18n.browseSettingsPageTitle.tr,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ObxValue<Rx<String>>(
              (Rx<String> data) {
                void updater(String? value) {
                  if (null != value) {
                    data.value = value;
                    settingsService.imageSource = value;
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final item in imageSourceItems)
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                        onTap: () => updater(item.value),
                        title: TextWidget(item.key, fontSize: 18, isBold: true),
                        trailing:
                            data.value == item.value ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 20) : null,
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
              settingsService.imageSource.obs,
            ),
            const Divider(),
            ObxValue(
              (Rx<bool> data) {
                void updater(bool? value) {
                  if (null != value) {
                    data.value = value;
                    settingsService.previewQuality = value;
                  }
                }

                return CupertinoSwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                  onTap: () => updater(!(true == data.value)),
                  title: TextWidget('${I18n.previewQuality.tr}(${I18n.largeImage.tr})', fontSize: 18, isBold: true),
                  value: data.value,
                );
              },
              settingsService.previewQuality.obs,
            ),
            ObxValue(
              (Rx<bool> data) {
                void updater(bool? value) {
                  if (null != value) {
                    data.value = value;
                    Get.find<SettingsService>().scaleQuality = value;
                  }
                }

                return CupertinoSwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                  onTap: () => updater(!(true == data.value)),
                  title: TextWidget('${I18n.scaleQuality.tr}(${I18n.originalImage.tr})', fontSize: 18, isBold: true),
                  value: data.value,
                );
              },
              Get.find<SettingsService>().scaleQuality.obs,
            ),
            const Divider(),
            ObxValue(
              (Rx<bool> data) {
                void updater(bool? value) {
                  if (null != value) {
                    data.value = value;
                    settingsService.enablePixivHistory = value;
                  }
                }

                return CupertinoSwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                  onTap: () => updater(!(true == data.value)),
                  title: TextWidget(I18n.enablePixivHistory.tr, fontSize: 18, isBold: true),
                  value: data.value,
                );
              },
              settingsService.enablePixivHistory.obs,
            ),
          ],
        ),
      ),
    );
  }
}
