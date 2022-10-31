// import 'dart:async';
//
// import 'package:dio/dio.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:pixiv_dart_api/model/message_thread.dart';
// import 'package:pixiv_dart_api/vo/message_thread_page_result.dart';
// import 'package:pixiv_func_mobile/app/api/web_api_client.dart';
// import 'package:pixiv_func_mobile/app/notification.dart';
// import 'package:pixiv_func_mobile/app/services/account_service.dart';
// import 'package:pixiv_func_mobile/app/services/chat_service.dart';
// import 'package:pixiv_func_mobile/utils/custom_timer.dart';
//
// class ChatListController extends GetxController implements GetxService {
//   static const _limit = 100;
//
//   final WebApiClient _webApiClient = Get.find();
//
//   final ChatService _chatService = Get.find();
//
//   final AccountService _accountService = Get.find();
//
//   CancelToken cancelToken = CancelToken();
//
//   final List<MessageThread> list = [];
//   CustomTimer? _timer;
//
//   @override
//   void onInit() async {
//     //从数据库获取聊天列表
//     list.addAll(await _chatService.query());
//     refreshTimer();
//     super.onInit();
//   }
//
//   void refreshTimer() {
//     _timer?.cancel();
//     _timer = null;
//
//     if (_accountService.current?.cookie != null) {
//       _timer = CustomTimer(const Duration(seconds: 10), refreshList);
//     }
//   }
//
//   Future<void> refreshList() async {
//     int offset = 0;
//     final List<MessageThread> tempList = [];
//     MessageThreadPageResult result = await _webApiClient.getLatestMessagePage(offset: offset, limit: _limit);
//     tempList.addAll(result.body.messageThreads);
//
//     while (null != result.body.nextUrl) {
//       offset += _limit;
//       result = await _webApiClient.getNextPage(result.body.nextUrl!, cancelToken: cancelToken);
//       tempList.addAll(result.body.messageThreads);
//     }
//
//     bool needUpdate = false;
//     if (list.isEmpty) {
//       _addAll(tempList);
//       needUpdate = true;
//     } else {
//       for (final thread in tempList) {
//         final index = list.indexWhere((item) => item.threadId == thread.threadId);
//         if (-1 == index) {
//           _add(thread);
//           needUpdate = true;
//         } else {
//           if (list[index].modifiedAt != thread.modifiedAt) {
//             _update(index, thread);
//             needUpdate = true;
//           }
//         }
//       }
//       if (needUpdate) {
//         _sort();
//         update();
//       }
//     }
//   }
//
//   String get a => "222";
//
//   void _add(MessageThread thread) {
//     list.add(thread);
//     _chatService.insert(userId: _accountService.currentUserId, thread: thread);
//   }
//
//   void _addAll(List<MessageThread> threads) {
//     list.addAll(threads);
//     _chatService.insertAll(userId: _accountService.currentUserId, threads: threads);
//   }
//
//   void _sort() {
//     list.sort((a, b) => int.parse(b.modifiedAt) > int.parse(a.modifiedAt) ? 1 : -1);
//   }
//
//   Future<void> _update(int index, MessageThread thread) async {
//     list[index] = thread;
//     _chatService.update(thread: thread);
//     final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       thread.threadName,
//       thread.threadName,
//       tag: thread.threadName,
//       channelDescription: '${thread.threadName}(${thread.unreadNum})',
//       channelShowBadge: false,
//       importance: Importance.max,
//       priority: Priority.high,
//       onlyAlertOnce: true,
//       enableVibration: false,
//       playSound: false,
//     );
//     final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         int.parse(thread.threadId), thread.threadName, thread.latestContent, platformChannelSpecifics);
//   }
// }
