import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/select_button/select_button.dart';
import 'package:pixiv_func_mobile/widgets/select_group/select_group.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class SearchIllustFilterEditorWidget extends StatelessWidget {
  final String keyword;
  final VoidCallback onFilterChanged;
  final ExpandableController expandableController;

  const SearchIllustFilterEditorWidget({Key? key, required this.keyword, required this.onFilterChanged, required this.expandableController})
      : super(key: key);

  String get tag => keyword;

  void openStartDatePicker() {
    final controller = Get.find<SearchIllustFilterEditorController>(tag: tag);
    showDatePicker(
      context: Get.context!,
      initialDate: controller.dateRange.start,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (null != value) {
        final currentDate = DateTime.now();
        final temp = controller.dateRange;
        //+1年
        final valuePlus1 = DateTime(value.year + 1, value.month, value.day);
        if (temp.end.isAfter(valuePlus1) || value.isAfter(temp.end)) {
          //start差距大于1年
          controller.dateRangeOnChanged(DateTimeRange(start: value, end: currentDate.isAfter(valuePlus1) ? valuePlus1 : currentDate));
        } else {
          //start差距小于1年
          controller.dateRangeOnChanged(DateTimeRange(start: value, end: temp.end));
        }
      }
    });
  }

  void openEndDatePicker() {
    final controller = Get.find<SearchIllustFilterEditorController>(tag: tag);
    showDatePicker(
      context: Get.context!,
      initialDate: controller.dateRange.end,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (null != value) {
        final temp = controller.dateRange;
        //-1年
        final minus1 = DateTime(value.year - 1, value.month, value.day);
        if (temp.start.isBefore(minus1) || value.isBefore(temp.start)) {
          //end差距大于1年
          controller.dateRangeOnChanged(DateTimeRange(start: minus1, end: value));
        } else {
          //end差距小于1年
          controller.dateRangeOnChanged(DateTimeRange(start: temp.start, end: value));
        }
      }
    });
  }

  Widget buildDateRangeEdit() {
    final controller = Get.find<SearchIllustFilterEditorController>(tag: tag);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => openStartDatePicker(),
          child: TextWidget(controller.startDate, fontSize: 16, forceStrutHeight: true),
        ),
        const Text(' - '),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => openEndDatePicker(),
          child: TextWidget(controller.endDate, fontSize: 16, forceStrutHeight: true),
        ),
      ],
    );
  }

  Widget buildDateRangeTypeEdit() {
    final controller = Get.find<SearchIllustFilterEditorController>(tag: tag);
    return SelectButtonWidget(
      items: {
        I18n.searchDateLimitNo.tr: 0,
        I18n.searchDateLimitDay.tr: 1,
        I18n.searchDateLimitWeek.tr: 2,
        I18n.searchDateLimitMonth.tr: 3,
        I18n.searchDateLimitHalfYear.tr: 4,
        I18n.searchDateLimitYear.tr: 5,
        I18n.searchDateLimitCustom.tr: 6,
      },
      value: controller.dateRangeType,
      onChanged: controller.dateTimeRangeTypeOnChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchIllustFilterEditorController>(
      tag: tag,
      builder: (controller) => ExpandablePanel(
        controller: expandableController,
        collapsed: const SizedBox(),
        expanded: Padding(
          padding: const EdgeInsets.fromLTRB(28, 5, 28, 12),
          child: Column(
            children: [
              SizedBox(
                height: 25,
                child: NoScrollBehaviorWidget(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => controller.editFilterChangeState(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(I18n.searchTarget.tr, fontSize: 14),
                            Icon(
                              controller.editFilterIndex == 0 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: controller.editFilterIndex == 0 ? Theme.of(context).colorScheme.primary : null,
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => controller.editFilterChangeState(1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(I18n.searchSort.tr, fontSize: 14),
                            Icon(
                              controller.editFilterIndex == 1 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: controller.editFilterIndex == 1 ? Theme.of(context).colorScheme.primary : null,
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => controller.editFilterChangeState(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(I18n.searchDateRange.tr, fontSize: 14),
                            Icon(
                              controller.editFilterIndex == 2 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: controller.editFilterIndex == 2 ? Theme.of(context).colorScheme.primary : null,
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => controller.editFilterChangeState(3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(I18n.searchBookmarkCount.tr, fontSize: 14),
                            Icon(
                              controller.editFilterIndex == 3 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: controller.editFilterIndex == 3 ? Theme.of(context).colorScheme.primary : null,
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ExpandablePanel(
                controller: controller.editFilterPanelController,
                collapsed: const SizedBox(),
                expanded: () {
                  final Widget widget;
                  switch (controller.editFilterIndex) {
                    case 0:
                      //居左
                      widget = SelectGroup<SearchSort>(
                        items: {
                          I18n.searchSortDateDesc.tr: SearchSort.dateDesc,
                          I18n.searchSortDateAsc.tr: SearchSort.dateAsc,
                          I18n.searchSortPopularDesc.tr: SearchSort.popularDesc,
                        },
                        value: controller.sort,
                        onChanged: controller.searchSortOnChanged,
                      );
                      break;
                    case 1:
                      widget = SelectGroup<SearchIllustTarget>(
                        items: {
                          I18n.searchTargetPartialMatchForTags.tr: SearchIllustTarget.partialMatchForTags,
                          I18n.searchTargetExactMatchForTags.tr: SearchIllustTarget.exactMatchForTags,
                          I18n.searchTargetTitleAndCaption.tr: SearchIllustTarget.titleAndCaption,
                        },
                        value: controller.target,
                        onChanged: controller.searchIllustTargetOnChanged,
                      );
                      break;
                    case 2:
                      widget = Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildDateRangeTypeEdit(),
                          if (controller.dateRangeType == 6) buildDateRangeEdit(),
                        ],
                      );
                      break;
                    case 3:
                      widget = Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Slider(
                              value: controller.bookmarkTotalSelected.toDouble(),
                              min: 0,
                              max: controller.bookmarkTotalItems.length - 1,
                              divisions: controller.bookmarkTotalItems.length - 1,
                              onChanged: controller.bookmarkTotalSliderOnChange,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextWidget(controller.bookmarkTotalText, fontSize: 14),
                          )
                        ],
                      );
                      break;
                    default:
                      widget = const SizedBox();
                      break;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      // height: 35,
                      alignment: Alignment.centerLeft,
                      child: widget,
                    ),
                  );
                }(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
