import 'package:extended_text/extended_text.dart';
import 'package:extra_hittest_area/extra_hittest_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/comment.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';
import 'package:pixiv_func_mobile/components/comment_input/emoji.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/components/translate/translate.dart';
import 'package:pixiv_func_mobile/pages/illust/comment/reply/reply.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        child: TranslateWidget(
                          text: comment.comment,
                          child: ExtendedText(
                            comment.comment,
                            style: const TextStyle(fontSize: 14),
                            specialTextSpanBuilder: EmojisSpecialTextSpanBuilder(multiple: 1.3),
                          ),
                        ),
                      ),
                    if (onReply != null && onDelete != null)
                      Row(
                        children: [
                          GestureDetectorHitTestWithoutSizeLimit(
                            extraHitTestArea: const EdgeInsets.all(16),
                            onTap: () => onReply!(),
                            child: const Icon(
                              Icons.reply_sharp,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 20),
                          if (Get.find<AccountService>().currentUserId == comment.user.id)
                            GestureDetectorHitTestWithoutSizeLimit(
                              extraHitTestArea: const EdgeInsets.all(16),
                              onTap: () => onDelete!(),
                              child: const Icon(
                                Icons.delete,
                                size: 20,
                              ),
                            ),
                          const Spacer(),
                          if (comment.hasReplies)
                            GestureDetectorHitTestWithoutSizeLimit(
                              behavior: HitTestBehavior.opaque,
                              extraHitTestArea: const EdgeInsets.all(16),
                              onTap: () {
                                Get.bottomSheet(
                                  ConstrainedBox(
                                    constraints: BoxConstraints(minHeight: Get.height * 0.9, maxHeight: Get.height * 0.9),
                                    child: IllustCommentReplyPage(
                                      parentComment: comment,
                                    ),
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              child: TextWidget('加载更多评论', color: Get.theme.colorScheme.primary),
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
    );
  }

}
