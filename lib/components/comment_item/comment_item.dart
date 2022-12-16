import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/comment.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';
import 'package:pixiv_func_mobile/app/services/translate_service.dart';
import 'package:pixiv_func_mobile/components/comment_input/emoji.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/pages/illust/comment/reply/reply.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class CommentItemWidget extends StatelessWidget {
  final Comment comment;

  final VoidCallback? onReply;
  final VoidCallback? onDelete;

  const CommentItemWidget({
    Key? key,
    required this.comment,
    this.onReply,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CommentItemController(comment), tag: comment.id.toString());
    return GetBuilder<CommentItemController>(
      tag: comment.id.toString(),
      dispose: (_) => Get.delete<CommentItemController>(tag: comment.id.toString()),
      builder: (controller) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressEnd: (details) {},
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() => UserPage(id: comment.user.id)),
                        child: PixivAvatarWidget(comment.user.profileImageUrls.medium, radius: 32),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            comment.user.name,
                            fontSize: 12,
                            isBold: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          TextWidget(
                            Utils.dateFormat(DateTime.parse(comment.date)),
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    //头像框的大小+边距
                    padding: const EdgeInsets.only(left: 32 + 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (null != comment.stamp)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Image.asset('assets/stamps/${comment.stamp!.stampId}.jpg'),
                          )
                        else if (comment.comment.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ExtendedText(
                                  comment.comment,
                                  style: const TextStyle(fontSize: 14),
                                  specialTextSpanBuilder: EmojisSpecialTextSpanBuilder(multiple: 1.3),
                                ),
                                if (controller.translateText != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Theme.of(context).colorScheme.surface,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            Get.find<TranslateService>().current.name,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          const Divider(),
                                          TextWidget(controller.translateText!, fontSize: 16),
                                        ],
                                      ),
                                    ),
                                  )
                                else if (controller.loading)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8).add(const EdgeInsets.only(bottom: 2)),
                                    child: const CupertinoActivityIndicator(),
                                  )
                              ],
                            ),
                          ),
                        if (onReply != null && onDelete != null)
                          Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => onReply!(),
                                child: Padding(
                                  padding: const EdgeInsets.all(5).subtract(const EdgeInsets.only(left: 5)),
                                  child: Icon(
                                    Icons.reply_sharp,
                                    color: Theme.of(context).dividerColor.withAlpha(150),
                                    size: 20,
                                  ),
                                ),
                              ),
                              if (comment.comment.isNotEmpty && controller.translateText == null && !controller.loading)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => controller.onTranslate(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.translate_outlined,
                                      color: Theme.of(context).dividerColor.withAlpha(150),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              if (Get.find<AccountService>().currentUserId == comment.user.id)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => onDelete!(),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.delete_outlined,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              const Spacer(),
                              if (comment.hasReplies)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Get.to(() => IllustCommentReplyPage(parentComment: comment));
                                  },
                                  child: Icon(
                                    Icons.more_horiz_outlined,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 20,
                                  ),
                                ),
                            ],
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
