import 'package:expandable/expandable.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/components/bookmark_switch_button/bookmark_switch_button.dart';
import 'package:pixiv_func_mobile/components/follow_switch_button/follow_switch_button.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/components/pixiv_image/pixiv_image.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/models/illust_save_state.dart';
import 'package:pixiv_func_mobile/pages/search/result/illust/search_illust_result.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/services/settings_service.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/sliver_headerr/sliver_tab_bar.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'comment/comment.dart';
import 'controller.dart';
import 'scale/scale.dart';
import 'ugoira_viewer/ugoira_viewer.dart';

class IllustPage extends StatelessWidget {
  final Illust illust;

  const IllustPage({required this.illust, Key? key}) : super(key: key);

  String get tag => 'Illust-${illust.id}';

  Widget buildImageItem({
    required int id,
    required String title,
    required String previewUrl,
    required int index,
  }) {
    final controller = Get.find<IllustController>(tag: tag);
    final widget = GestureDetector(
      onTap: () => Get.to(() => ImageScalePage(illust: illust, initialPage: index)),
      onLongPress: () => controller.downloadModeChangeState(),
      child: Stack(
        children: [
          PixivImageWidget(
            previewUrl,
            width: double.infinity,
            color: controller.downloadMode
                ? Get.isDarkMode
                    ? Colors.black45
                    : Colors.white24
                : null,
            colorBlendMode: controller.downloadMode ? BlendMode.srcOver : null,
            placeholderWidget: SizedBox(
              height: 200,
              width: double.infinity,
              child: Center(
                child: CupertinoActivityIndicator(color: Get.theme.colorScheme.onSurface),
              ),
            ),
            fit: BoxFit.fitWidth,
          ),
          if (controller.downloadMode)
            Positioned(
              top: 20,
              right: 20,
              child: () {
                switch (controller.illustStates[index]) {
                  case IllustSaveState.none:
                    return GestureDetector(
                      onTap: () => controller.download(index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.file_download_outlined,
                          size: 30,
                        ),
                      ),
                    );
                  case IllustSaveState.downloading:
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case IllustSaveState.error:
                    return GestureDetector(
                      onTap: () => controller.download(index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.file_download_outlined,
                          size: 30,
                        ),
                      ),
                    );
                  case IllustSaveState.exist:
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Get.theme.colorScheme.primary,
                        size: 30,
                      ),
                    );
                  default:
                    return const SizedBox();
                }
              }(),
            ),
        ],
      ),
    );
    return 0 == index ? Hero(tag: 'IllustHero-$id', child: widget) : widget;
  }

  Widget buildUgoiraViewer({
    required int id,
    required String previewUrl,
  }) {
    final controller = Get.find<IllustController>(tag: tag);
    return GestureDetector(
      onLongPress: () => controller.downloadModeChangeState(),
      child: Stack(
        children: [
          UgoiraViewer(
            id: id,
            previewUrl: previewUrl,
          ),
          if (controller.downloadMode)
            Positioned(
              top: 20,
              right: 20,
              child: () {
                switch (controller.illustStates[0]) {
                  case IllustSaveState.none:
                    return GestureDetector(
                      onTap: () => controller.downloadGif(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.file_download_outlined,
                          size: 30,
                        ),
                      ),
                    );
                  case IllustSaveState.downloading:
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case IllustSaveState.error:
                    return GestureDetector(
                      onTap: () => controller.downloadGif(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.file_download_outlined,
                          size: 30,
                        ),
                      ),
                    );
                  case IllustSaveState.exist:
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Get.theme.colorScheme.primary,
                        size: 30,
                      ),
                    );
                  default:
                    return const SizedBox();
                }
              }(),
            ),
        ],
      ),
    );
  }

  Widget buildImageDetail() {
    final controller = Get.find<IllustController>(tag: tag);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Get.to(() => UserPage(id: illust.user.id)),
                child: PixivAvatarWidget(illust.user.profileImageUrls.medium, radius: 48),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      illust.user.name,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                      isBold: true,
                    ),
                    TextWidget(
                      illust.user.account,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
              FollowSwitchButton(
                id: illust.user.id,
                userName: illust.user.name,
                userAccount: illust.user.account,
                initValue: illust.user.isFollowed ?? false,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextWidget(
                I18n.uploadDate.trArgs([Utils.dateFormat(DateTime.parse(illust.createDate))]),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 5),
              const Icon(Icons.remove_red_eye_outlined, size: 12),
              const SizedBox(width: 5),
              TextWidget(
                '${illust.totalView}',
                forceStrutHeight: true,
              ),
              const SizedBox(width: 5),
              const Icon(Icons.favorite_border, size: 12),
              const SizedBox(width: 5),
              TextWidget(
                '${illust.totalBookmarks}',
                forceStrutHeight: true,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Share.share(
                      '[Pixiv Func]\n${illust.title}\n${I18n.illustId.tr}:${illust.id}\nhttps://www.pixiv.net/artworks/${illust.id}');
                },
                child: Row(
                  children: [
                    TextWidget(I18n.resolution.trArgs(['${illust.width}x${illust.height}'])),
                    const SizedBox(width: 5),
                    TextWidget('${I18n.illustId.tr}: ${illust.id}'),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.share_outlined,
                      size: 12,
                    ),
                  ],
                ),
              ),
              if (controller.illust.caption.isNotEmpty)
                GestureDetector(
                  onTap: () => controller.showCommentChangeState(),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      TextWidget(
                        I18n.summary.tr,
                        color: controller.showCaption ? Get.theme.colorScheme.primary : null,
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        controller.showCaption ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: controller.showCaption ? Get.theme.colorScheme.primary : null,
                        size: 12,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          ExpandablePanel(
            controller: controller.captionPanelController,
            collapsed: const SizedBox(),
            expanded: Container(
              padding: const EdgeInsets.only(bottom: 20),
              alignment: Alignment.topLeft,
              child: HtmlRichText(controller.illust.caption),
            ),
            theme: const ExpandableThemeData(
              hasIcon: false,
            ),
          ),
          Wrap(
            children: [
              for (final tag in illust.tags)
                GestureDetector(
                  onTap: () {
                    if (controller.blockMode) {
                      controller.blockTagChangeState(tag);
                    } else {
                      Get.to(() => SearchIllustResultPage(keyword: tag.name));
                    }
                  },
                  onLongPress: () => controller.blockModeChangeState(),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Get.theme.colorScheme.surface,
                          ),
                          child: TextWidget(
                            '#${tag.name} ${tag.translatedName != null ? ' ${tag.translatedName}' : ''}',
                            fontSize: 14,
                            forceStrutHeight: true,
                          ),
                        ),
                      ),
                      if (controller.blockMode)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            AppIcons.blocked,
                            size: 15,
                            color: controller.blockTagService.isBlocked(tag) ? Get.theme.colorScheme.primary : null,
                          ),
                        )
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(IllustController(illust), tag: tag);
    return GetBuilder<IllustController>(
      tag: tag,
      assignId: true,
      builder: (controller) => DefaultTabController(
        length: 2,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (controller.downloadMode) {
              controller.downloadModeChangeState();
            }
          },
          child: VisibilityDetector(
            key: Key(tag),
            onVisibilityChanged: (VisibilityInfo info) {
              controller.isVisibility = info.visibleFraction != 0.0;
            },
            child: ScaffoldWidget(
              titleWidget: TextWidget(illust.title, isBold: true),
              actions: [
                if (controller.downloadMode)
                  SizedBox(
                    width: kToolbarHeight,
                    // alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => controller.downloadAll(),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.file_download_outlined),
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          right: 5,
                          // 忽略点击事件让点击事件穿透到下面的按钮
                          child: IgnorePointer(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextWidget(
                                () {
                                  final count = controller.illustStates.values
                                      .where((element) => IllustSaveState.none == element || IllustSaveState.error == element)
                                      .length;
                                  return count == illust.pageCount ? I18n.all.tr : '$count';
                                }(),
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: BookmarkSwitchButton(
                    id: illust.id,
                    title: illust.title,
                    initValue: illust.isBookmarked,
                    isButton: false,
                  ),
                ),
              ],
              child: NoScrollBehaviorWidget(
                child: ExtendedNestedScrollView(
                  controller: controller.scrollController,
                  onlyOneScrollInBody: true,
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
                    if (illust.isUgoira)
                      SliverToBoxAdapter(
                        child: buildUgoiraViewer(
                          id: illust.id,
                          previewUrl: Get.find<SettingsService>().getPreviewUrl(illust.imageUrls),
                        ),
                      )
                    else if (1 == illust.pageCount)
                      SliverToBoxAdapter(
                        child: buildImageItem(
                          id: illust.id,
                          title: illust.title,
                          previewUrl: Get.find<SettingsService>().getPreviewUrl(illust.imageUrls),
                          index: 0,
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            for (var index = 0; index < illust.metaPages.length; ++index)
                              buildImageItem(
                                id: illust.id,
                                title: illust.title,
                                previewUrl: Get.find<SettingsService>().getPreviewUrl(illust.metaPages[index].imageUrls),
                                index: index,
                              ),
                          ],
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: buildImageDetail(),
                    ),
                    SliverPersistentHeader(
                      delegate: SliverHeader(
                        child: PreferredSize(
                          preferredSize: const Size.fromHeight(kToolbarHeight),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 0.5,
                                color: const Color(0xFF373737),
                              ),
                              TabBarWidget(
                                indicatorMinWidth: 15,
                                onTap: (index) {
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  }
                                },
                                indicator: const RRecTabIndicator(
                                  radius: 4,
                                  insets: EdgeInsets.only(bottom: 5),
                                ),
                                tabs: [
                                  TabWidget(text: I18n.recommend.tr),
                                  TabWidget(text: I18n.comment.tr),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      pinned: true,
                      floating: true,
                    ),
                  ],
                  pinnedHeaderSliverHeightBuilder: () => kToolbarHeight,
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      DataContent(
                        sourceList: controller.illustRelatedSource,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, Illust item, bool visibility, int index) =>
                            IllustPreviewer(illust: item, square: true, useHero: visibility),
                      ),
                      IllustCommentContent(id: illust.id),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
