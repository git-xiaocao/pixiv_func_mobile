import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/encrypt/encrypt.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/models/account.dart';
import 'package:pixiv_func_mobile/pages/home/home.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';

class LoginController extends GetxController {
  bool _useLocalReverseProxy = true;
  bool _help = false;

  bool get useLocalReverseProxy => _useLocalReverseProxy;

  set useLocalReverseProxy(bool value) {
    _useLocalReverseProxy = value;
    update();
  }

  bool get help => _help;

  set help(bool value) {
    _help = value;
    update();
  }

  void loginWithClipboard() async {
    try {
      final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
      if (null == text) {
        PlatformApi.toast(I18n.getClipboardDataFailed.tr);
        return;
      } else if (text.isEmpty) {
        PlatformApi.toast(I18n.clipboardDataEmpty.tr);
        return;
      }
      final clipboardDataString = Encrypt.decode(text.trim());
      final json = jsonDecode(clipboardDataString);
      final account = Account.fromJson(json);
      Get.find<AccountService>().add(account);
      Get.offAll(const HomePage());
      PlatformApi.toast(I18n.loginSuccess.tr);
    } catch (e) {
      PlatformApi.toast(I18n.clipboardAccountDataInvalid.tr);
    }
  }
}
