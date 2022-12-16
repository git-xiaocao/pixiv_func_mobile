import 'dart:ui';

class Settings {
  bool guideInit;

  int theme;

  String imageSource;

  bool previewQuality;

  bool scaleQuality;

  bool enableHistory;

  bool enablePixivHistory;

  String language;

  int translateIndex;

  Map<String, String> translateAuthData;

  Settings({
    required this.guideInit,
    required this.theme,
    required this.imageSource,
    required this.previewQuality,
    required this.scaleQuality,
    required this.enableHistory,
    required this.enablePixivHistory,
    required this.language,
    required this.translateIndex,
    required this.translateAuthData,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      guideInit: json['guideInit'] as bool,
      theme: json['theme'] as int,
      imageSource: json['imageSource'] as String,
      previewQuality: json['previewQuality'] as bool,
      scaleQuality: json['scaleQuality'] as bool,
      enablePixivHistory: json['enablePixivHistory'] as bool,
      enableHistory: json['enableHistory'] as bool,
      language: json['language'] as String,
      translateIndex: json['translateIndex'] as int,
      translateAuthData: (json['translateAuthData'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guideInit': guideInit,
      'theme': theme,
      'imageSource': imageSource,
      'previewQuality': previewQuality,
      'scaleQuality': scaleQuality,
      'enableHistory': enableHistory,
      'enablePixivHistory': enablePixivHistory,
      'language': language,
      'translateIndex': translateIndex,
      'translateAuthData': translateAuthData,
    };
  }

  factory Settings.defaultValue() => Settings(
        guideInit: false,
        theme: -1,
        imageSource: '210.140.92.148',
        previewQuality: true,
        scaleQuality: true,
        enableHistory: true,
        enablePixivHistory: true,
        language: window.locale.toLanguageTag(),
        translateIndex: 0,
        translateAuthData: {},
      );
}
