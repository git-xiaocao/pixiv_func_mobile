import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/pages/home/home.dart';
import 'package:pixiv_func_mobile/pages/login/login.dart';
import 'package:pixiv_func_mobile/pages/welcome/welcome.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';

class IndexWidget extends StatelessWidget {
  const IndexWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.find<SettingsService>().guideInit) {
      return const WelcomePage();
    } else {
      if (Get.find<AccountService>().isEmpty) {
        return const LoginPage();
      } else {
        return const HomePage();
      }
    }
  }
}
