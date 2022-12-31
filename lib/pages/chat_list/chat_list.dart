// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pixiv_dart_api/model/message_thread.dart';
// import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
// import 'package:pixiv_func_mobile/global_controllers/chat_list_controller.dart';
// import 'package:pixiv_func_mobile/pages/chat_thread/chat_thread.dart';
// import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
// import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
// import 'package:pixiv_func_mobile/widgets/text/text.dart';
//
// class ChatListPage extends StatelessWidget {
//   const ChatListPage({Key? key}) : super(key: key);
//
//   String _dateTimeToString(DateTime dateTime) {
//     final now = DateTime.now();
//     if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
//       return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//     } else if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day - 1) {
//       return '昨天 ${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//     } else if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day - 2) {
//       return '前天 ${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//     } else if (dateTime.year == now.year) {
//       return '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//     } else {
//       return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}';
//     }
//   }
//
//   Widget buildItem(MessageThread thread) {
//     return InkWell(
//       onTap: () => Get.to(
//         () => ChatThreadPage(
//           name: thread.threadName,
//           threadId: int.parse(thread.threadId),
//           receiveId: 0,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: PixivAvatarWidget(thread.iconUrl.px100x100, radius: 60),
//             ),
//             Expanded(
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(child: TextWidget(thread.threadName, fontSize: 16)),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: TextWidget(
//                           _dateTimeToString(DateTime.fromMillisecondsSinceEpoch(int.parse(thread.modifiedAt) * 1000)),
//                           color: Get.theme.colorScheme.onSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Expanded(child: TextWidget(thread.latestContent, fontSize: 12, overflow: TextOverflow.ellipsis, maxLines: 1)),
//                       if (int.parse(thread.unreadNum) > 0)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
//                             decoration: BoxDecoration(color: Get.theme.colorScheme.primary, borderRadius: BorderRadius.circular(4)),
//                             child: TextWidget(thread.unreadNum),
//                           ),
//                         ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ChatListController>(
//       builder: (controller) => ScaffoldWidget(
//         title: '聊天列表',
//         child: NoScrollBehaviorWidget(
//           child: ListView(
//             children: [
//               for (final item in controller.list) buildItem(item),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
