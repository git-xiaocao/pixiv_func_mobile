import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'source.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final source = HistoryListSource();
    return ScaffoldWidget(
      title: I18n.historyPageTitle.tr,
      actions: [
        IconButton(
          onPressed: () {
            Get.bottomSheet(
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: Get.height * 0.35, minHeight: Get.height * 0.35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(flex: 1),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextWidget('删除全部历史记录', fontSize: 18, isBold: true),
                      ),
                      const Spacer(flex: 1),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextWidget('删除后将不可恢复', fontSize: 16),
                      ),
                      const Spacer(flex: 2),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                elevation: 0,
                                color: Theme.of(context).colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  side: BorderSide.none,
                                ),
                                minWidth: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: TextWidget(I18n.cancel.tr, fontSize: 18, color: Colors.white, isBold: true),
                                ),
                                onPressed: () => Get.back(),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: MaterialButton(
                                elevation: 0,
                                color: Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                minWidth: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: TextWidget(I18n.confirm.tr, fontSize: 18, color: Colors.white, isBold: true),
                                ),
                                onPressed: () async {
                                  await source.clearItem();
                                  Get.back();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            );
          },
          icon: const Icon(Icons.delete_forever_outlined),
        ),
      ],
      child: Column(
        children: [
          const Divider(),
          ValueBuilder<bool?>(
            builder: (bool? snapshot, void Function(bool?) updater) {
              return CupertinoSwitchListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                onTap: () => updater(!snapshot),
                title: TextWidget(I18n.browsingHistory.tr, fontSize: 18, isBold: true),
                value: snapshot!,
              );
            },
            initialValue: Get.find<SettingsService>().enableHistory,
            onUpdate: (bool? value) {
              if (null != value) {
                Get.find<SettingsService>().enableHistory = value;
              }
            },
          ),
          const Divider(),
          Expanded(
            child: DataContent<Illust>(
              sourceList: source,
              extendedListDelegate:
                  const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
              itemBuilder: (BuildContext context, Illust item, bool visibility, int index) => InkWell(
                onLongPress: () {
                  Get.bottomSheet(
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                        color: Theme.of(context).colorScheme.background,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: Get.height * 0.35, minHeight: Get.height * 0.35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(flex: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: TextWidget(I18n.deleteThisHistory.tr, fontSize: 18, isBold: true),
                            ),
                            const Spacer(flex: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: TextWidget(I18n.deleteThisHistoryHint.tr, fontSize: 16),
                            ),
                            const Spacer(flex: 2),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      elevation: 0,
                                      color: Theme.of(context).colorScheme.surface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        side: BorderSide.none,
                                      ),
                                      minWidth: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: TextWidget(I18n.cancel.tr, fontSize: 18, color: Colors.white, isBold: true),
                                      ),
                                      onPressed: () => Get.back(),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: MaterialButton(
                                      elevation: 0,
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      minWidth: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: TextWidget(I18n.confirm.tr, fontSize: 18, color: Colors.white, isBold: true),
                                      ),
                                      onPressed: () async {
                                        await source.removeItem(item.id);
                                        Get.back();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: IllustPreviewer(illust: item, useHero: visibility),
              ),
              pullToRefresh: false,
            ),
          ),
        ],
      ),
    );
  }
}
