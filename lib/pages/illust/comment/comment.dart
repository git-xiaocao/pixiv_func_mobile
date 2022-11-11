import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/comment.dart';
import 'package:pixiv_func_mobile/components/comment_input/comment_input.dart';
import 'package:pixiv_func_mobile/components/comment_item/comment_item.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';

import 'controller.dart';

class IllustCommentContent extends StatelessWidget {
  final int id;

  const IllustCommentContent({Key? key, required this.id}) : super(key: key);

  String get tag => '$id';

  @override
  Widget build(BuildContext context) {
    Get.put(IllustCommentController(id), tag: tag);
    return GetBuilder<IllustCommentController>(
      tag: tag,
      builder: (IllustCommentController controller) {
        return Column(
          children: [
            Flexible(
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
            CommentInputWidget(
              resetReply: () => controller.repliesComment = null,
              hasReply: controller.repliesComment != null,
              onSend: (text) => controller.onCommentAdd(text: text),
              onStampSend: (int id) => controller.onCommentAdd(stampId: id),
              label: controller.commentInputLabel,
            ),
          ],
        );
      },
    );
  }
}
