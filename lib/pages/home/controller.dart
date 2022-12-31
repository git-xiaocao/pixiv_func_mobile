import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/url_scheme/url_scheme.dart';
import 'package:pixiv_func_mobile/pages/search/result/image/search_image.dart';
import 'package:pixiv_func_mobile/pages/search/result/image/search_image_result.dart';
import 'package:pixiv_func_mobile/pages/search/search.dart';
import 'package:pixiv_func_mobile/pages/user/me.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:share_handler/share_handler.dart';
import 'package:uni_links2/uni_links.dart' as uni_links;

class HomeController extends GetxController {
  final PageController pageController = PageController();

  int _index = 0;

  int get index => _index;

  set index(int value) {
    _index = value;
    update();
  }

  @override
  void onInit() {
    const QuickActions()
      ..initialize((type) {
        switch (type) {
          case 'action_user':
            Get.to(const MePage());
            break;
          case 'action_search':
            Get.to(const SearchPage());
            break;
          case 'action_search_image':
            Get.to(const SearchImagePage());
            break;
        }
      })
      ..setShortcutItems(
        //倒着排序
        [
          ShortcutItem(type: 'action_user', localizedTitle: I18n.user.tr, icon: 'icon_user'),
          ShortcutItem(type: 'action_search', localizedTitle: I18n.search.tr, icon: 'icon_search'),
          ShortcutItem(type: 'action_search_image', localizedTitle: I18n.searchImage.tr, icon: 'icon_search_image'),
        ].reversed.toList(),
      );

    uni_links.getInitialLink().then((url) async {
      if (null != url) {
        await UrlScheme.handler(url);
      }
    });

    uni_links.linkStream.listen((url) async {
      if (null != url) {
        await UrlScheme.handler(url);
      }
    });

    ShareHandlerPlatform.instance.getInitialSharedMedia().then((media) {
      if (true == media?.attachments?.isNotEmpty) {
        final filepath = media!.attachments!.first!.path;
        final imageBytes = File(filepath).readAsBytesSync();
        final filename = filepath.split('/').last;
        Get.to(SearchImageResultPage(imageBytes: imageBytes, filename: filename));
      }
    });

    ShareHandlerPlatform.instance.sharedMediaStream.listen((media) {
      if (true == media.attachments?.isNotEmpty) {
        final filepath = media.attachments!.first!.path;
        final imageBytes = File(filepath).readAsBytesSync();
        final filename = filepath.split('/').last;
        Get.to(SearchImageResultPage(imageBytes: imageBytes, filename: filename));
      }
    });

    super.onInit();
  }
}
