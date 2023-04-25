import 'dart:ui';

class Settings {
  bool guideInit;

  int theme;

  String imageSource;

  bool previewQuality;

  bool scaleQuality;

  bool enableHistory;

  bool enablePixivHistory;

  bool enableLocalBlockR18;

  bool enableLocalBlockAI;

  String language;

  int translateIndex;

  Map<String, String> translateAuthData;

  int maxDownloadCount;

  String? savePath;

  String? saveFolder;

  String? namingRule;

  Settings({
    required this.guideInit,
    required this.theme,
    required this.imageSource,
    required this.previewQuality,
    required this.scaleQuality,
    required this.enableHistory,
    required this.enablePixivHistory,
    required this.enableLocalBlockR18,
    required this.enableLocalBlockAI,
    required this.language,
    required this.translateIndex,
    required this.translateAuthData,
    required this.maxDownloadCount,
    required this.savePath,
    required this.saveFolder,
    required this.namingRule,
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
      enableLocalBlockR18: json['enableLocalBlockR18'] as bool? ?? false,
      enableLocalBlockAI: json['enableLocalBlockAI'] as bool? ?? false,
      language: json['language'] as String,
      translateIndex: json['translateIndex'] as int,
      translateAuthData: (json['translateAuthData'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String)),
      maxDownloadCount: json['maxDownloadCount'] as int,
      savePath: json['savePath'] as String?,
      saveFolder: json['saveFolder'] as String?,
      namingRule: json['namingRule'] as String?,
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
      'enableLocalBlockR18': enableLocalBlockR18,
      'enableLocalBlockAI': enableLocalBlockAI,
      'language': language,
      'translateIndex': translateIndex,
      'translateAuthData': translateAuthData,
      'maxDownloadCount': maxDownloadCount,
      'savePath': savePath,
      'saveFolder': saveFolder,
      'namingRule': namingRule,
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
        enableLocalBlockR18: false,
        enableLocalBlockAI: false,
        language: window.locale.toLanguageTag(),
        translateIndex: 0,
        translateAuthData: {},
        maxDownloadCount: 3,
        savePath: null,
        saveFolder: null,
        namingRule: null,
      );
}
