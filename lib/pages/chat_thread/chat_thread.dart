// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pixiv_dart_api/model/message_thread_content.dart';
// import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
// import 'package:pixiv_func_mobile/components/pixiv_image/pixiv_image.dart';
// import 'package:pixiv_func_mobile/pages/chat_thread/controller.dart';
// import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
// import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
// import 'package:pixiv_func_mobile/widgets/text/text.dart';
//
// class ChatThreadPage extends StatelessWidget {
//   final String name;
//   final int threadId;
//   final int receiveId;
//
//   const ChatThreadPage({Key? key, required this.name, required this.threadId, required this.receiveId}) : super(key: key);
//
//   String get tag => '$runtimeType-$threadId';
//
//   Widget buildItem(MessageThreadContent message) {
//     final controller = Get.find<ChatThreadController>(tag: tag);
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(17, 6, 17, 6),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: controller.isMe(message) ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (controller.isMe(message))
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 13),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: Get.theme.cardColor,
//                       ),
//                       child: () {
//                         if (message.content.type == 'text') {
//                           return Padding(
//                             padding: const EdgeInsets.all(6),
//                             child: TextWidget('${message.content.text}', forceStrutHeight: true),
//                           );
//                         } else {
//                           int width = int.parse(message.content.width!);
//                           int height = int.parse(message.content.height!);
//                           double scaleWidth, scaleHeight;
//                           if (width > 400 || height > 400) {
//                             if (width > height) {
//                               scaleWidth = 400;
//                               scaleHeight = 400 * height / width;
//                             } else {
//                               scaleWidth = 400 * width / height;
//                               scaleHeight = 400;
//                             }
//                           } else {
//                             scaleWidth = width.toDouble();
//                             scaleHeight = height.toDouble();
//                           }
//
//                           return ClipRRect(
//                             borderRadius: BorderRadius.circular(5),
//                             child: PixivImageWidget(
//                               message.content.imageUrls!.px400x400,
//                               width: scaleWidth,
//                               height: scaleHeight,
//                             ),
//                           );
//                         }
//                       }(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           PixivAvatarWidget(message.user.iconUrl.mainS),
//           if (!controller.isMe(message))
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: Get.theme.cardColor,
//                       ),
//                       child: () {
//                         if (message.content.type == 'text') {
//                           return Padding(
//                             padding: const EdgeInsets.all(6),
//                             child: TextWidget('${message.content.text}', forceStrutHeight: true),
//                           );
//                         } else {
//                           int width = int.parse(message.content.width!);
//                           int height = int.parse(message.content.height!);
//                           double scaleWidth, scaleHeight;
//                           if (width > 400 || height > 400) {
//                             if (width > height) {
//                               scaleWidth = 400;
//                               scaleHeight = 400 * height / width;
//                             } else {
//                               scaleWidth = 400 * width / height;
//                               scaleHeight = 400;
//                             }
//                           } else {
//                             scaleWidth = width.toDouble();
//                             scaleHeight = height.toDouble();
//                           }
//
//                           return ClipRRect(
//                             borderRadius: BorderRadius.circular(5),
//                             child: PixivImageWidget(
//                               message.content.imageUrls!.px400x400,
//                               width: scaleWidth,
//                               height: scaleHeight,
//                             ),
//                           );
//                         }
//                       }(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Get.put(ChatThreadController(threadId, receiveId), tag: tag);
//     return GetBuilder<ChatThreadController>(
//       tag: tag,
//       builder: (controller) => ScaffoldWidget(
//         title: name,
//         child: Column(
//           children: [
//             Flexible(
//               child: NoScrollBehaviorWidget(
//                 child: ListView(
//                   // reverse: true,
//                   children: [
//                     for (final content in controller.list) buildItem(content),
//                   ],
//                 ),
//               ),
//             ),
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: controller.onImageMessageSend,
//                   icon: const Icon(
//                     Icons.image,
//                   ),
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: controller.messageContentInput,
//                     decoration: InputDecoration(
//                       prefix: const SizedBox(width: 5),
//                       suffixIcon: InkWell(
//                         onTap: () => controller.messageContentInput.clear(),
//                         child: const Icon(
//                           Icons.close_sharp,
//                           color: Colors.white54,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 5),
//                   child: ElevatedButton(
//                     onPressed: controller.onTextMessageSend,
//                     child: const TextWidget('发送'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
