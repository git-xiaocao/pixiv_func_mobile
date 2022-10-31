import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/components/follow_switch_button/follow_switch_button.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/components/pixiv_image/pixiv_image.dart';
import 'package:pixiv_func_mobile/pages/user/about/about.dart';
import 'package:pixiv_func_mobile/widgets/auto_keep/auto_keep.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/sliver_headerr/sliver_tab_bar.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';
import 'package:share_plus/share_plus.dart';

import 'bookmark/bookmark.dart';
import 'controller.dart';
import 'following/following.dart';
import 'work/work.dart';

class UserPage extends StatefulWidget {
  final int id;

  const UserPage({Key? key, required this.id}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  String get tag => '$runtimeType-${widget.id}';

  Widget buildAppBar() {
    final controller = Get.find<UserController>(tag: tag);
    final userDetail = controller.userDetailResult!;
    final String? backgroundImageUrl = userDetail.profile.backgroundImageUrl;
    final UserInfo user = userDetail.user;

    return ExtendedSliverAppbar(
      toolbarHeight: kToolbarHeight,
      toolBarColor: Get.theme.colorScheme.background,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PixivAvatarWidget(
            user.profileImageUrls.medium,
            radius: 24,
          ),
          const SizedBox(width: 10),
          TextWidget(user.name, fontSize: 16),
        ],
      ),
      background: Container(
        color: Get.theme.colorScheme.background,
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.3 + 50,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (null != backgroundImageUrl)
                    Container(
                      height: Get.height * 0.3,
                      color: Theme.of(Get.context!).colorScheme.surface,
                      child: PixivImageWidget(
                        backgroundImageUrl,
                        height: Get.height * 0.3,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    )
                  else
                    Container(
                      height: Get.height * 0.3,
                      color: Theme.of(Get.context!).colorScheme.surface,
                    ),
                  Positioned(
                    top: Get.height * 0.3 - 50,
                    child: PixivAvatarWidget(
                      user.profileImageUrls.medium,
                      radius: 100,
                    ),
                  )
                ],
              ),
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextWidget(user.name, fontSize: 16),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Share.share('[Pixiv Func]\n${user.name}\n用户ID:${user.id}\nhttps://www.pixiv.net/users/${user.id}');
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.share_outlined, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(AppIcons.follow, size: 14),
                const SizedBox(width: 5),
                TextWidget('${userDetail.profile.totalFollowUsers}'),
                const SizedBox(width: 10),
                const Icon(AppIcons.friend, size: 14),
                const SizedBox(width: 5),
                TextWidget('${userDetail.profile.totalMyPixivUsers}'),
              ],
            ),
            const SizedBox(height: 10),
            FollowSwitchButton(
              id: user.id,
              userName: user.name,
              userAccount: user.account,
              initValue: user.isFollowed,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserController(widget.id, this), tag: tag);
    return GetBuilder<UserController>(
      tag: tag,
      builder: (controller) => ScaffoldWidget(
        emptyAppBar: controller.userDetailResult != null,
        title: I18n.userIdPageTitle.trArgs([widget.id.toString()]),
        child: () {
          if (PageState.loading == controller.state) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          } else if (PageState.error == controller.state) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => controller.loadData(),
              child: Container(
                alignment: Alignment.center,
                child: const TextWidget('加载失败,点击重试', fontSize: 16),
              ),
            );
          } else if (PageState.notFound == controller.state) {
            return Container(
              alignment: Alignment.center,
              child: TextWidget(I18n.userIdNotFound.trArgs([widget.id.toString()]), fontSize: 16),
            );
          } else if (PageState.complete == controller.state) {
            return NoScrollBehaviorWidget(
              child: ExtendedNestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
                  buildAppBar(),
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
                          NoScrollBehaviorWidget(
                            child: TabBarWidget(
                              onTap: controller.tabOnTap,
                              isScrollable: true,
                              controller: controller.tabController,
                              indicatorMinWidth: 15,
                              labelColor: Theme.of(context).colorScheme.primary,
                              unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                              indicator: const RRecTabIndicator(
                                radius: 4,
                                insets: EdgeInsets.only(bottom: 5),
                              ),
                              tabs: [
                                TabWidget(
                                  text: I18n.work.tr,
                                  icon: controller.tabController.index == 0
                                      ? controller.expandTypeSelector
                                          ? const Icon(Icons.keyboard_arrow_up, size: 12)
                                          : const Icon(Icons.keyboard_arrow_down, size: 12)
                                      : null,
                                  iconSize: 12,
                                  inScrolls: true,
                                ),
                                TabWidget(
                                  text: I18n.bookmarked.tr,
                                  icon: controller.tabController.index == 1
                                      ? controller.expandTypeSelector
                                          ? const Icon(Icons.keyboard_arrow_up, size: 12)
                                          : const Icon(Icons.keyboard_arrow_down, size: 12)
                                      : null,
                                  iconSize: 12,
                                  inScrolls: true,
                                ),
                                TabWidget(
                                  text: I18n.follow.tr,
                                  iconSize: 12,
                                  inScrolls: true,
                                ),
                                TabWidget(
                                  text: I18n.about.tr,
                                  iconSize: 12,
                                  inScrolls: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                    pinned: true,
                    floating: true,
                  )
                ],
                pinnedHeaderSliverHeightBuilder: () => kToolbarHeight * 2,
                onlyOneScrollInBody: true,
                body: TabBarView(
                  controller: controller.tabController,
                  children: [
                    AutomaticKeepWidget(
                      child: UserWorkContent(id: widget.id, expandTypeSelector: controller.expandTypeSelector),
                    ),
                    AutomaticKeepWidget(
                      child: UserBookmarkContent(id: widget.id, restrict: controller.restrict, expandTypeSelector: controller.expandTypeSelector),
                    ),
                    AutomaticKeepWidget(
                      child: UserFollowingContent(id: widget.id, restrict: controller.restrict),
                    ),
                    AutomaticKeepWidget(
                      child: UserAboutContent(userDetail: controller.userDetailResult!),
                    ),
                  ],
                ),
              ),
            );
          }
        }(),
      ),
    );
  }
}
