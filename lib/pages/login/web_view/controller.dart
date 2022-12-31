import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/auth_client.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/platform/webview/controller.dart';
import 'package:pixiv_func_mobile/models/account.dart';
import 'package:pixiv_func_mobile/pages/home/home.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class LoginWebViewController extends GetxController {
  final bool create;

  LoginWebViewController(this.create);

  final TextEditingController accountInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();

  late final PlatformWebViewController webViewController;

  bool _isLoginPage = false;

  bool get isLoginPage => _isLoginPage;

  String _title = '';

  String get title => _title;

  void onWebViewCreated(PlatformWebViewController controller) {
    webViewController = controller;
    initUrl();
  }

  Future<void> initCheatScript() async {
    final cheatJs = await rootBundle.loadString('assets/cheat.js');
    await webViewController.evaluateJavascript(cheatJs);
  }

  Future<bool> cheatCheatScript() async {
    final result = await webViewController.evaluateJavascript('\'undefined\' !== typeof caoCheat');
    return 'true' == result;
  }

  void initUrl() {
    if (create) {
      //直接去注册 注册完再登录免得再去设置邮箱
      webViewController.loadUrl('https://accounts.pixiv.net/signup');
      return;
    }
    String baseUrl = 'https://app-api.pixiv.net/web/v1/login';
    baseUrl += '?code_challenge=';
    baseUrl += Get.find<AuthClient>().codeChallenge;
    baseUrl += '&code_challenge_method=S256&client=pixiv-android';
    webViewController.loadUrl(baseUrl);
  }

  void onMessageHandler(Map message) async {
    switch (message['type'] as String) {
      case 'pageStarted':
        final content = message['data'] as String;
        final uri = Uri.parse(content);
        _title = uri.host;
        update();
        break;
      case 'pageFinished':
        if (!await cheatCheatScript()) {
          await initCheatScript();
        }
        final result = await webViewController.evaluateJavascript('isLoginPage()');
        _isLoginPage = 'true' == result;
        update();
        if (isLoginPage) {
          webViewController.evaluateJavascript('removePasswordMask()');
        }
        break;
      case 'account':
        final uri = Uri.parse(message['data'] as String);
        final SettingsService settingsService = Get.find();
        final AccountService accountService = Get.find();
        final AuthClient authClient = Get.find();
        authClient.initAccountAuthToken(uri.queryParameters['code'] as String).then((result) {
          Log.i(result);

          PlatformApi.toast(I18n.loginSuccess.tr);

          final firstAccount = accountService.isEmpty;

          accountService.add(Account(message['cookie'] as String, result));
          settingsService.guideInit = true;

          if (firstAccount) {
            Get.offAll(const HomePage());
          } else {
            Get.back();
          }
        }).catchError((e) {
          Log.e('登录失败', e);
        });
        break;
    }
  }

  void getLoginDataFromWebView() async {
    final result = await webViewController.evaluateJavascript('getLoginData()');
    final data = jsonDecode(result) as Map<String, dynamic>;
    accountInputController.text = data['account'];
    passwordInputController.text = data['password'];
  }

  void copyLoginDataToWebView() {
    webViewController.evaluateJavascript('changeLoginData(\'${accountInputController.text}\',\'${passwordInputController.text}\');');
  }
}
