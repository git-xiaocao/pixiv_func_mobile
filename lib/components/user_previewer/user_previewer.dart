import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/user_preview.dart';
import 'package:pixiv_func_mobile/components/follow_switch_button/follow_switch_button.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class UserPreviewer extends StatelessWidget {
  final UserPreview userPreview;
  final bool useHero;

  const UserPreviewer({
    Key? key,
    required this.userPreview,
    required this.useHero,
  }) : super(key: key);

  static const double padding = 3;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => UserPage(id: userPreview.user.id)),
                  child: PixivAvatarWidget(userPreview.user.profileImageUrls.medium, radius: 48),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        userPreview.user.name,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                        isBold: true,
                      ),
                      TextWidget(
                        userPreview.user.account,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                FollowSwitchButton(
                  id: userPreview.user.id,
                  userName: userPreview.user.name,
                  userAccount: userPreview.user.account,
                  initValue: userPreview.user.isFollowed!,
                ),
              ],
            ),
          ),
          if (userPreview.illusts.isNotEmpty)
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final itemWidth = constraints.maxWidth / 3;
                return SizedBox(
                  width: constraints.maxWidth,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < userPreview.illusts.length; ++i)
                        SizedBox(
                          width: itemWidth,
                          child: IllustPreviewer(
                            illust: userPreview.illusts[i],
                            square: true,
                            borderRadius: BorderRadius.only(
                              bottomLeft: i == 0 ? const Radius.circular(12) : Radius.zero,
                              bottomRight: i == userPreview.illusts.length - 1 ? const Radius.circular(12) : Radius.zero,
                            ),
                            useHero: useHero,
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
