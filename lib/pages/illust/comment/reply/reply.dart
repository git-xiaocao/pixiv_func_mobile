import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/comment.dart';
import 'package:pixiv_func_mobile/components/comment_input/comment_input.dart';
import 'package:pixiv_func_mobile/components/comment_item/comment_item.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class IllustCommentReplyPage extends StatelessWidget {
  final Comment parentComment;

  const IllustCommentReplyPage({Key? key, required this.parentComment}) : super(key: key);

  String get tag => '${parentComment.id}';

  @override
  Widget build(BuildContext context) {
    Get.put(IllustCommentReplyController(parentComment.id), tag: tag);
    return GetBuilder<IllustCommentReplyController>(
      tag: tag,
      builder: (controller) {
        return ScaffoldWidget(
          child: Column(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommentItemWidget(comment: parentComment),
                    const Padding(
                      padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                      child: TextWidget('评论回复', fontSize: 18),
                    ),
                    Expanded(
                      child: DataContent(
                        sourceList: controller.source,
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, Comment item, bool visibility, int index) => CommentItemWidget(
                          comment: item,
                          onReply: () => controller.repliesComment = item,
                          onDelete: () => controller.onCommentDelete(item),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CommentInputWidget(
                resetReply: () => controller.repliesComment = null,
                hasReply: controller.repliesComment != null,
                onSend: (text) => controller.onCommentAdd(text: text),
                onStampSend: (int id) => controller.onCommentAdd(stampId: id),
                label: controller.commentInputLabel,
              ),
            ],
          ),
        );
      },
    );
  }
}
