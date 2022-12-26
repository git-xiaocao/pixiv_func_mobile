import 'dart:convert';

import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/image_urls.dart';
import 'package:pixiv_func_mobile/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends GetxService {
  late final SharedPreferences _sharedPreferences;

  late final Settings _settings;

  Future<SettingsService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = _sharedPreferences.getString('settings');
    if (null != jsonString) {
      //升级兼容
      try {
        _settings = Settings.fromJson(jsonDecode(jsonString));
      } catch (e) {
        await _sharedPreferences.remove('settings');
        _settings = Settings.defaultValue();
      }
    } else {
      _settings = Settings.defaultValue();
    }
    return this;
  }

  void save() {
    _sharedPreferences.setString('settings', jsonEncode(_settings.toJson()));
  }

  bool get guideInit => _settings.guideInit;

  set guideInit(bool value) {
    _settings.guideInit = value;
    save();
  }

  int get theme => _settings.theme;

  set theme(int value) {
    _settings.theme = value;
    save();
  }

  String get imageSource => _settings.imageSource;

  set imageSource(String value) {
    _settings.imageSource = value;
    save();
  }

  bool get previewQuality => _settings.previewQuality;

  set previewQuality(bool value) {
    _settings.previewQuality = value;
    save();
  }

  bool get scaleQuality => _settings.scaleQuality;

  set scaleQuality(bool value) {
    _settings.scaleQuality = value;
    save();
  }

  bool get enableHistory => _settings.enableHistory;

  set enableHistory(bool value) {
    _settings.enableHistory = value;
    save();
  }

  bool get enablePixivHistory => _settings.enablePixivHistory;

  set enablePixivHistory(bool value) {
    _settings.enablePixivHistory = value;
    save();
  }

  String get language => _settings.language;

  set language(String value) {
    _settings.language = value;
    save();
  }

  int get translateIndex => _settings.translateIndex;

  set translateIndex(int value) {
    _settings.translateIndex = value;
    save();
  }

  Map<String, String> get translateAuthData => _settings.translateAuthData;

  set translateAuthData(Map<String, String> value) {
    _settings.translateAuthData = value;
    save();
  }

  int get maxDownloadCount => _settings.maxDownloadCount;

  set maxDownloadCount(int value) {
    _settings.maxDownloadCount = value;
    save();
  }

  String toCurrentImageSource(String url, [String host = 'i.pximg.net']) {
    return url.replaceFirst(host, imageSource);
  }

  String getPreviewUrl(ImageUrls imageUrls) {
    return previewQuality ? imageUrls.large : imageUrls.medium;
  }
}
