import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/widgets/lazy_indexed_stack/lazy_indexed_stack.dart';
import 'package:pixiv_func_mobile/widgets/select_button/select_button.dart';
import 'package:pixiv_func_mobile/widgets/select_group/select_group.dart';

import 'controller.dart';
import 'illust/source.dart';
import 'novel/source.dart';

class FollowNewContent extends StatefulWidget {
  final bool expandTypeSelector;

  const FollowNewContent({Key? key, required this.expandTypeSelector}) : super(key: key);

  @override
  State<FollowNewContent> createState() => _FollowNewContentState();
}

class _FollowNewContentState extends State<FollowNewContent> {
  @override
  void didUpdateWidget(covariant FollowNewContent oldWidget) {
    if (widget.expandTypeSelector != oldWidget.expandTypeSelector) {
      Get.find<FollowNewController>().expandableController.expanded = widget.expandTypeSelector;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(FollowNewController());
    return GetBuilder<FollowNewController>(
      builder: (controller) => Column(
        children: [
          ExpandablePanel(
            controller: controller.expandableController,
            collapsed: const SizedBox(),
            expanded: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SelectGroup<WorkType>(
                      items: {I18n.illustAndManga.tr: WorkType.illust, I18n.novel.tr: WorkType.novel},
                      value: controller.workType,
                      onChanged: controller.workTypeOnChanged,
                    ),
                  ),
                  SelectButtonWidget<Restrict?>(
                    items: {
                      I18n.all.tr: null,
                      I18n.restrictPublic.tr: Restrict.public,
                      I18n.restrictPrivate.tr: Restrict.private,
                    },
                    value: controller.restrict,
                    onChanged: controller.restrictOnChanged,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: LazyIndexedStack(
              index: controller.workType == WorkType.illust ? 0 : 1,
              children: [
                DataContent<Illust>(
                  key: Key('FloolowNewIllust-${controller.restrict}'),
                  sourceList: FollowNewIllustListSource(controller.restrict),
                  extendedListDelegate:
                      const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
                  itemBuilder: (BuildContext context, Illust item, bool visibility, int index) => IllustPreviewer(
                    illust: item,
                    useHero: visibility,
                  ),
                ),
                DataContent<Novel>(
                  key: Key('FloolowNewNovel-${controller.restrict}'),
                  sourceList: FollowNewNovelListSource(controller.restrict),
                  itemBuilder: (BuildContext context, Novel item, bool visibility, int index) => NovelPreviewer(novel: item),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
