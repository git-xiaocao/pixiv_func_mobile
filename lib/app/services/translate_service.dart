import 'dart:convert';

import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/translate/google.dart';
import 'package:pixiv_func_mobile/app/translate/translate_base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslateService extends GetxService {
  late final SharedPreferences _sharedPreferences;

  late final Map<String, dynamic> translateConfig;

  late final List<TranslateBase> translates;

  Future<TranslateService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    try {
      translateConfig = jsonDecode(config);
    } catch (_) {
      translateConfig = <String, dynamic>{};
    }
    translates = [
      GoogleTranslate(),
    ];
    return this;
  }

  int get index => _sharedPreferences.getInt('index') ?? 0;

  set index(int value) {
    _sharedPreferences.setInt('index', value);
  }

  String get config => _sharedPreferences.getString('config') ?? '';

  set config(String value) {
    _sharedPreferences.setString('config', value);
  }

  void update() {
    _sharedPreferences.setString('config', jsonEncode(translateConfig));
  }

  TranslateBase get current => translates[index];
}
