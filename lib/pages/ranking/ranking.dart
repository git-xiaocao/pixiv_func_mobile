import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';

import 'content/source.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: RankingMode.values.length,
      child: ScaffoldWidget(
        titleWidget: NoScrollBehaviorWidget(
          child: TabBarWidget(
            indicatorMinWidth: 15,
            isScrollable: true,
            indicator: const RRecTabIndicator(
              radius: 4,
              insets: EdgeInsets.only(bottom: 5),
            ),
            tabs: [
              TabWidget(text: I18n.rankingItemDay.tr),
              TabWidget(text: I18n.rankingItemDayR18.tr),
              TabWidget(text: I18n.rankingItemDayMale.tr),
              TabWidget(text: I18n.rankingItemDayMaleR18.tr),
              TabWidget(text: I18n.rankingItemDayFemale.tr),
              TabWidget(text: I18n.rankingItemDayFemaleR18.tr),
              TabWidget(text: I18n.rankingItemWeek.tr),
              TabWidget(text: I18n.rankingItemWeekR18.tr),
              TabWidget(text: I18n.rankingItemWeekOriginal.tr),
              TabWidget(text: I18n.rankingItemWeekRookie.tr),
              TabWidget(text: I18n.rankingItemMonth.tr),
            ],
          ),
        ),
        child: TabBarView(
          children: [
            for (int i = 0; i < RankingMode.values.length; ++i)
              DataContent<Illust>(
                sourceList: RankingListSource(RankingMode.values[i]),
                extendedListDelegate:
                    const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
                itemBuilder: (BuildContext context, Illust item, bool visibility, int index) => IllustPreviewer(
                  illust: item,
                  useHero: visibility,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
