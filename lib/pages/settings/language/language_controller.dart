import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n_expansion.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n_translations.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';

class LanguageController extends GetxController {
  String _language = Get.find<SettingsService>().language;

  String get language => _language;

  void languageOnChange(String? value) {
    if (null != value) {
      _language = value;
      Get.find<SettingsService>().language = value;
      final list = value.split('_');
      Get.updateLocale(Locale(list.first, list.last));
    }
  }

  void clearExpansion() {
    I18nTranslations.clearExpansion();
    update();
  }

  void getExpansionFromGithub() async {
    Dio().get<String>('https://raw.githubusercontent.com/git-xiaocao/pixiv_func_i18n_expansion/main/i18n_expansion/expansions.json').then((response) async {
      final list = jsonDecode(response.data!) as List<dynamic>;
      int count = 0;
      for (final item in list) {
        final jsonString = (await Dio().get<String>('https://raw.githubusercontent.com/git-xiaocao/pixiv_func_i18n_expansion/main/i18n_expansion/$item')).data!;

        final expansion = I18nExpansion.fromJson(jsonDecode(jsonString));
        final index = I18nTranslations.expansions.indexWhere((e) => e.locale == expansion.locale);
        if (-1 != index) {
          if (I18nTranslations.expansions[index].versionCode > expansion.versionCode) {
            await I18nTranslations.addExpansion(expansion);
            ++count;
          }
        } else {
          await I18nTranslations.addExpansion(expansion);
          ++count;
        }
      }
      if (count > 0) {
        PlatformApi.toast(I18n.updateLanguageExpansionHint.trArgs([count.toString()]));
      } else {
        PlatformApi.toast(I18n.noUpdateLanguageExpansionHint.tr);
      }
    });
  }
}
