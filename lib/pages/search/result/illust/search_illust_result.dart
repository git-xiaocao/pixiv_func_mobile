import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';
import 'filter_editor/controller.dart';
import 'filter_editor/search_illust_filter_editor.dart';

class SearchIllustResultPage extends StatelessWidget {
  final String keyword;

  const SearchIllustResultPage({Key? key, required this.keyword}) : super(key: key);

  String get controllerTag => '$runtimeType-$keyword';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchIllustResultController(keyword), tag: controllerTag);

    return GetBuilder<SearchIllustResultController>(
      tag: controllerTag,
      initState: (state) {
        Get.put(SearchIllustFilterEditorController(controller.onFilterChanged), tag: 'SearchIllustFilterEditor-$keyword');
      },
      dispose: (state) {
        Get.delete<SearchIllustFilterEditorController>(tag: 'SearchIllustFilterEditor-$keyword');
      },
      builder: (controller) => ScaffoldWidget(
        automaticallyImplyLeading: false,
        titleWidget: SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.back(edit: true),
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController(text: keyword),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        gapPadding: 0,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      hintText: I18n.search.tr,
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onBackground),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 3),
                      fillColor: Theme.of(context).colorScheme.surface,
                      filled: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.back(),
                child: TextWidget(I18n.cancel.tr, color: Theme.of(context).colorScheme.onSecondary),
              ),
              const SizedBox(width: 25),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.expandedFilterChangeState(),
                child: Icon(AppIcons.filter, color: controller.expandedFilter ? Theme.of(context).colorScheme.primary : null),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                children: [
                  SearchIllustFilterEditorWidget(
                    keyword: keyword,
                    onFilterChanged: controller.onFilterChanged,
                    expandableController: controller.filterPanelController,
                  ),
                  Expanded(
                    child: DataContent<Illust>(
                      sourceList: controller.sourceList,
                      extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, Illust item, bool visibility, int index) => IllustPreviewer(
                        illust: item,
                        useHero: visibility,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
