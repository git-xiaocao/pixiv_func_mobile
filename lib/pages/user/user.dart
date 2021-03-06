import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_mobile/components/follow_switch_button/follow_switch_button.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
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
  String get controllerTag => '$runtimeType-${widget.id}';

  Widget _buildAppBar() {
    final controller = Get.find<UserController>(tag: controllerTag);
    final userDetail = controller.userDetailResult!;
    final String? backgroundImageUrl = userDetail.profile.backgroundImageUrl;
    final UserInfo user = userDetail.user;

    return ExtendedSliverAppbar(
      toolbarHeight: kToolbarHeight,
      toolBarColor: Get.theme.colorScheme.background,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarFromUrl(
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
                      child: ImageFromUrl(
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
                      alignment: Alignment.center,
                      child: const TextWidget('??????????????????', fontSize: 16),
                    ),
                  Positioned(
                    top: Get.height * 0.3 - 50,
                    child: AvatarFromUrl(
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
                    Share.share('[Pixiv Func]\n${user.name}\n??????ID:${user.id}\nhttps://www.pixiv.net/users/${user.id}');
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
    Get.put(UserController(widget.id, this), tag: controllerTag);
    return GetBuilder<UserController>(
      tag: controllerTag,
      builder: (controller) => ScaffoldWidget(
        emptyAppBar: controller.userDetailResult != null,
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
                child: const TextWidget('????????????,????????????', fontSize: 16),
              ),
            );
          } else if (PageState.notFound == controller.state) {
            return Container(
              alignment: Alignment.center,
              child: TextWidget('??????ID${widget.id}?????????', fontSize: 16),
            );
          } else if (PageState.complete == controller.state) {
            return NoScrollBehaviorWidget(
              child: ExtendedNestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
                  _buildAppBar(),
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
                            onTap: controller.tabOnTap,
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
                                text: '??????',
                                icon: controller.tabController.index == 0
                                    ? controller.expandTypeSelector
                                        ? const Icon(Icons.keyboard_arrow_up, size: 12)
                                        : const Icon(Icons.keyboard_arrow_down, size: 12)
                                    : null,
                              ),
                              TabWidget(
                                text: '??????',
                                icon: controller.tabController.index == 1
                                    ? controller.expandTypeSelector
                                        ? const Icon(Icons.keyboard_arrow_up, size: 12)
                                        : const Icon(Icons.keyboard_arrow_down, size: 12)
                                    : null,
                              ),
                              const TabWidget(
                                text: '??????',
                              ),
                              const TabWidget(
                                text: '??????',
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                    pinned: true,
                    floating: true,
                  )
                ],
                pinnedHeaderSliverHeightBuilder: () => kToolbarHeight * 2,
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
