import 'dart:ui';

import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/image_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends GetxService {
  late final SharedPreferences _sharedPreferences;

  Future<SettingsService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  bool get guideInit => _sharedPreferences.getBool('guide_init') ?? false;

  set guideInit(bool value) => _sharedPreferences.setBool('guide_init', value);

  int get theme => _sharedPreferences.getInt('theme') ?? -1;

  set theme(int value) {
    _sharedPreferences.setInt('theme', value);
  }

  String get imageSource => _sharedPreferences.getString('image_source') ?? '210.140.92.148';

  set imageSource(String value) {
    _sharedPreferences.setString('image_source', value);
  }

  String toCurrentImageSource(String url, [String host = 'i.pximg.net']) {
    return url.replaceFirst(host, imageSource);
  }

  String getPreviewUrl(ImageUrls imageUrls) {
    return previewQuality ? imageUrls.large : imageUrls.medium;
  }

  bool get previewQuality => _sharedPreferences.getBool('preview_quality') ?? true;

  set previewQuality(bool value) {
    _sharedPreferences.setBool('preview_quality', value);
  }

  bool get scaleQuality => _sharedPreferences.getBool('scale_quality') ?? true;

  set scaleQuality(bool value) {
    _sharedPreferences.setBool('scale_quality', value);
  }

  bool get enableHistory => _sharedPreferences.getBool('enable_history') ?? true;

  set enableHistory(bool value) {
    _sharedPreferences.setBool('enable_history', value);
  }

  String get language => _sharedPreferences.getString('language') ?? window.locale.toLanguageTag();

  set language(String value) {
    _sharedPreferences.setString('language', value);
  }
}
