import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/live.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/components/pixiv_image/pixiv_image.dart';
import 'package:pixiv_func_mobile/pages/live/live.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class LivePreviewer extends StatelessWidget {
  final Live live;

  const LivePreviewer({Key? key, required this.live}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            //固定的
            final previewHeight = constraints.maxWidth * 0.56;

            final Widget widget;
            if (null == live.thumbnailImageUrl) {
              widget = Container(
                width: double.infinity,
                height: previewHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: const TextWidget('无封面'),
              );
            } else {
              widget = Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: PixivImageWidget(live.thumbnailImageUrl!, width: double.infinity, height: previewHeight, fit: BoxFit.fitWidth),
                  ),
                  Positioned(
                    right: 5,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.supervisor_account, color: Colors.white, size: 16),
                          const SizedBox(width: 5),
                          TextWidget(live.memberCount.toString(), fontSize: 12, color: Colors.white),
                          const SizedBox(width: 5),
                          const Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 16),
                          const SizedBox(width: 5),
                          TextWidget(live.totalAudienceCount.toString(), fontSize: 12, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Row(
                      children: [
                        for (final item in live.performers)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: PixivAvatarWidget(item.user.profileImageUrls.medium, radius: 30),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return GestureDetector(
              onTap: () => Get.to(() => LivePage(
                    live: live,
                  )),
              child: widget,
            );
          },
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    live.name,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    isBold: true,
                  ),
                ],
              ),
            ),
            if (live.isEnabledMicInput) const Icon(Icons.mic) else const Icon(Icons.mic_off),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10),
            PixivAvatarWidget(live.owner.user.profileImageUrls.medium, radius: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    live.owner.user.name,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    isBold: true,
                  ),
                  TextWidget(
                    live.owner.user.account,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
