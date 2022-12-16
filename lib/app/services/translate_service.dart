import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/app/translate/google.dart';
import 'package:pixiv_func_mobile/app/translate/translate_base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslateService extends GetxService {
  late final SharedPreferences _sharedPreferences;

  late final Map<String, dynamic> translateConfig;

  late final List<TranslateBase> translates;

  Future<TranslateService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    translates = [
      GoogleTranslate(),
    ];
    return this;
  }

  TranslateBase get current => translates[Get.find<SettingsService>().translateIndex];
}
