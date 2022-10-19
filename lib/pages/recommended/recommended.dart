import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_dart_api/model/live.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_dart_api/model/user_preview.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/live_previewer/live_previewer.dart';
import 'package:pixiv_func_mobile/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_mobile/components/user_previewer/user_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/pages/recommended/live/source.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';

import 'illust/source.dart';
import 'novel/source.dart';
import 'user/source.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: ScaffoldWidget(
        titleWidget: NoScrollBehaviorWidget(
          child: TabBarWidget(
            indicatorMinWidth: 15,
            isScrollable: true,
            padding: EdgeInsets.zero,
            indicator: const RRecTabIndicator(
              radius: 4,
              insets: EdgeInsets.only(bottom: 5),
            ),
            tabs: [
              TabWidget(text: I18n.illust.tr),
              TabWidget(text: I18n.manga.tr),
              TabWidget(text: I18n.novel.tr),
              TabWidget(text: I18n.user.tr),
              TabWidget(text: I18n.live.tr),
            ],
          ),
        ),
        child: TabBarView(
          children: [
            DataContent<Illust>(
              sourceList: RecommendedIllustListSource(IllustType.illust),
              extendedListDelegate:
                  const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
              itemBuilder: (BuildContext context, Illust item, bool visibility, int index) => IllustPreviewer(
                illust: item,
                useHero: visibility,
              ),
            ),
            DataContent<Illust>(
              sourceList: RecommendedIllustListSource(IllustType.manga),
              extendedListDelegate:
                  const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
              itemBuilder: (BuildContext context, Illust item, bool visibility, int index) => IllustPreviewer(
                illust: item,
                useHero: visibility,
              ),
            ),
            DataContent<Novel>(
              sourceList: RecommendedNovelListSource(),
              itemBuilder: (BuildContext context, Novel item, bool visibility, int index) => NovelPreviewer(novel: item),
            ),
            DataContent<UserPreview>(
              sourceList: RecommendedUserListSource(),
              itemBuilder: (BuildContext context, UserPreview item, bool visibility, int index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: UserPreviewer(
                  userPreview: item,
                  useHero: visibility,
                ),
              ),
            ),
            DataContent<Live>(
              sourceList: RecommendedLiveListSource(),
              extendedListDelegate:
                  const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
              itemBuilder: (BuildContext context, Live item, bool visibility, int index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: LivePreviewer(live: item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
