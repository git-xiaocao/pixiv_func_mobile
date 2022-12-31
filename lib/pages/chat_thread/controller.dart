// import 'dart:async';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:pixiv_dart_api/model/message_thread_content.dart';
// import 'package:pixiv_func_mobile/app/api/web_api_client.dart';
// import 'package:pixiv_func_mobile/pages/image_selector/image_selector.dart';
// import 'package:pixiv_func_mobile/app/services/account_service.dart';
// import 'package:pixiv_func_mobile/app/services/message_service.dart';
//
// class ChatThreadController extends GetxController {
//   int threadId;
//   int receiveId;
//
//   ChatThreadController(this.threadId, this.receiveId);
//
//   static const _limit = 100;
//
//   bool init = false;
//
//   String? _nextUrl;
//
//   final WebApiClient _webApiClient = Get.find();
//
//   final MessageService _messageService = Get.find();
//
//   final AccountService _accountService = Get.find();
//
//   final TextEditingController messageContentInput = TextEditingController();
//
//   final List<MessageThreadContent> list = [];
//
//   final CancelToken cancelToken = CancelToken();
//
//   late final Timer _timer;
//
//   @override
//   void onInit() async {
//     //从数据库获取消息内容
//     list.addAll(await _messageService.query(threadId: threadId));
//     if (list.isNotEmpty) {
//       _sort();
//       update();
//     }
//     _loadData();
//     _timer = Timer(const Duration(seconds: 5), () => _refreshLatestData());
//     super.onInit();
//   }
//
//   Future<void> _refreshLatestData() async {
//     final tempList = await _loadFirst();
//
//     for (final message in tempList) {
//       if (!_exist(message)) {
//         _add(message);
//         update();
//       }
//     }
//   }
//
//   Future<void> _loadData() async {
//     final List<MessageThreadContent> tempList;
//     if (!init) {
//       init = true;
//       tempList = await _loadFirst();
//     } else {
//       if (_nextUrl == null) {
//         return;
//       }
//       tempList = await _loadNext();
//     }
//
//     bool needUpdate = false;
//     if (list.isEmpty) {
//       _addAll(tempList);
//       needUpdate = true;
//     } else {
//       for (final message in tempList) {
//         if (!_exist(message)) {
//           _add(message);
//           needUpdate = true;
//         }
//       }
//     }
//
//     if (needUpdate) {
//       _sort();
//       update();
//     }
//   }
//
//   Future<List<MessageThreadContent>> _loadFirst() {
//     return _webApiClient.getMessageContentPage(threadId: threadId, limit: _limit, cancelToken: cancelToken).then((result) {
//       _nextUrl = result.body.nextUrl;
//       return result.body.messageThreadContents;
//     });
//   }
//
//   Future<List<MessageThreadContent>> _loadNext() {
//     return _webApiClient.getNextPage(_nextUrl!, cancelToken: cancelToken).then((result) {
//       _nextUrl = result.body.nextUrl;
//       return result.body.messageThreadContents;
//     });
//   }
//
//   void _add(MessageThreadContent message) {
//     list.add(message);
//     _messageService.insert(threadId: threadId, message: message);
//   }
//
//   void _addAll(List<MessageThreadContent> messages) {
//     list.addAll(messages);
//     _messageService.insertAll(threadId: threadId, messages: messages);
//   }
//
//   void _sort() {
//     list.sort((a, b) => int.parse(b.createAt) > int.parse(a.createAt) ? 1 : -1);
//   }
//
//   bool _exist(MessageThreadContent message) => list.any((item) => item.contentId == message.contentId);
//
//   bool isMe(MessageThreadContent message) {
//     return message.user.userId == _accountService.currentUserId.toString();
//   }
//
//   void onTextMessageSend() async {
//     _webApiClient
//         .postMessageContent(
//       threadId: threadId,
//       text: messageContentInput.text,
//     )
//         .then(
//       (result) {
//         messageContentInput.clear();
//         _refreshLatestData();
//       },
//     );
//   }
//
//   void onImageMessageSend() {
//     Get.to(
//       () => ImageSelectorPage(
//         onChanged: (imageInfo) async {
//           _webApiClient
//               .postMessageContent(
//             threadId: threadId,
//             imageBytes: imageInfo.bytes,
//           )
//               .then(
//             (result) {
//               _refreshLatestData();
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   void onClose() {
//     cancelToken.cancel();
//     _timer.cancel();
//     super.onClose();
//   }
// }
