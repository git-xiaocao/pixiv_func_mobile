abstract class TranslateBase {
  /// 授权数据getter
  final String Function()? authDataGetter;

  /// [authDataGetter] - 授权数据getter
  TranslateBase(this.authDataGetter);

  /// 需要授权数据
  bool get needAuthData => authDataGetter != null;

  /// 名称
  String get name;

  /// 支持中国大陆
  bool get isSupportChina;

  /// 翻译文本
  ///
  /// [source] - 从什么语言(为null时是auto)
  ///
  /// [target] - 翻译到什么语言
  Future<String> translationText({
    required String text,
    required String? source,
    required String target,
  });
}
