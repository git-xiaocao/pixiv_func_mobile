import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/pixiv_auth.dart';

class AuthClient extends GetxService with PixivAuth {
  Future<AuthClient> initSuper() async {
    final deviceInfo = DeviceInfoPlugin();
    final String model;
    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      model = info.model ?? 'CAO';
    } else {
      final info = await deviceInfo.androidInfo;
      model = info.model ?? 'CAO';
    }

    super.init(
      targetIPGetter: () => "210.140.92.183",
      languageGetter: () => Get.locale!.toLanguageTag(),
      deviceName: model,
    );
    return this;
  }
}
