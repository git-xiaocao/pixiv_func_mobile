import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/illust/id_search/id_search.dart';
import 'package:pixiv_func_mobile/pages/search/result/image/search_image.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'controller.dart';

class SearchPage extends StatefulWidget {
  final String? initValue;

  const SearchPage({Key? key, this.initValue}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Get.put(SearchInputController(this, widget.initValue));
    return GetBuilder<SearchInputController>(
      builder: (controller) => VisibilityDetector(
        key: Key(runtimeType.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction != 0.0) {
            controller.focusNode.requestFocus();
          }
        },
        child: ScaffoldWidget(
          automaticallyImplyLeading: false,
          titleWidget: SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: controller.focusNode,
                    controller: controller.searchContentInput,
                    onChanged: (value) => controller.searchContentOnChanged(value),
                    onSubmitted: (value) => controller.toSearchResultPage(value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        gapPadding: 0,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      hintText: I18n.searchHint.tr,
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onBackground),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 3),
                      fillColor: Theme.of(context).colorScheme.surface,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.back(),
                  child: TextWidget(I18n.cancel.tr, color: Theme.of(context).colorScheme.onSecondary),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    color: const Color(0xFFFF6289),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.image_search, color: Colors.white, size: 14),
                    onPressed: () => Get.to(const SearchImagePage()),
                  ),
                ),
              ],
            ),
          ),
          child: Column(
            children: [
              NoScrollBehaviorWidget(
                child: TabBarWidget(
                  isScrollable: true,
                  controller: controller.tabController,
                  indicatorMinWidth: 15,
                  indicator: const RRecTabIndicator(
                    radius: 4,
                    insets: EdgeInsets.only(bottom: 5),
                  ),
                  tabs: [
                    TabWidget(text: I18n.illustAndManga.tr),
                    TabWidget(text: I18n.novel.tr),
                    TabWidget(text: I18n.user.tr),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    NoScrollBehaviorWidget(
                      child: ListView(
                        children: [
                          if (controller.inputIsNotEmpty)
                            if (controller.inputIsNumber)
                              ListTile(
                                onTap: () => Get.to(() => IllustIdSearchPage(id: controller.inputAsNumber)),
                                title:
                                    TextWidget(I18n.searchItem.trArgs([controller.inputAsNumber.toString()]), fontSize: 16, isBold: true),
                                subtitle: TextWidget(I18n.illustId.tr, fontSize: 12),
                              )
                            else
                              ListTile(
                                onTap: () => controller.toSearchResultPage(controller.inputAsString),
                                title:
                                    TextWidget(I18n.searchItem.trArgs([controller.inputAsString.toString()]), fontSize: 16, isBold: true),
                                subtitle: TextWidget(I18n.keyword.tr, fontSize: 14),
                              ),
                          for (final tag in controller.autocompleteTags)
                            ListTile(
                              onTap: () => controller.toSearchResultPage(tag.name),
                              title: TextWidget(tag.name, fontSize: 16, isBold: true),
                              subtitle: null != tag.translatedName ? TextWidget(tag.translatedName!, fontSize: 12) : null,
                            ),
                        ],
                      ),
                    ),
                    NoScrollBehaviorWidget(
                      child: ListView(
                        children: [
                          if (controller.inputIsNotEmpty)
                            if (controller.inputIsNumber)
                              ListTile(
                                onTap: () => controller.toSearchResultPage(controller.inputAsString),
                                title:
                                    TextWidget(I18n.searchItem.trArgs([controller.inputAsNumber.toString()]), fontSize: 16, isBold: true),
                                subtitle: TextWidget(I18n.novelId.tr, fontSize: 12),
                              )
                            else
                              ListTile(
                                onTap: () => controller.toSearchResultPage(controller.inputAsString),
                                title:
                                    TextWidget(I18n.searchItem.trArgs([controller.inputAsString.toString()]), fontSize: 16, isBold: true),
                                subtitle: TextWidget(I18n.keyword.tr, fontSize: 14),
                              ),
                          for (final tag in controller.autocompleteTags)
                            ListTile(
                              onTap: () => controller.toSearchResultPage(tag.name),
                              title: TextWidget(tag.name, fontSize: 16, isBold: true),
                              subtitle: null != tag.translatedName ? TextWidget(tag.translatedName!, fontSize: 12) : null,
                            ),
                        ],
                      ),
                    ),
                    NoScrollBehaviorWidget(
                      child: ListView(
                        children: [
                          if (controller.inputIsNotEmpty)
                            if (controller.inputIsNumber)
                              ListTile(
                                onTap: () => Get.to(() => UserPage(id: controller.inputAsNumber)),
                                title:
                                    TextWidget(I18n.searchItem.trArgs([controller.inputAsNumber.toString()]), fontSize: 16, isBold: true),
                                subtitle: TextWidget(I18n.keyword.tr, fontSize: 12),
                              )
                            else
                              ListTile(
                                onTap: () => controller.toSearchResultPage(controller.inputAsString),
                                title:
                                    TextWidget(I18n.searchItem.trArgs([controller.inputAsString.toString()]), fontSize: 16, isBold: true),
                                subtitle: TextWidget(I18n.keyword.tr, fontSize: 14),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
