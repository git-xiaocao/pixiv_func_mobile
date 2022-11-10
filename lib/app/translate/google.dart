import 'package:dio/dio.dart';
import 'package:pixiv_func_mobile/app/translate/translate_base.dart';

class GoogleTranslate extends TranslateBase {
  GoogleTranslate() : super(null);

  @override
  bool get isSupportChina => false;

  @override
  String get name => 'Google Translate';

  @override
  Future<String> translationText({
    required String text,
    required String? source,
    required String target,
  }) async {
    // return text;
    return Dio().get<String>(
      'https://translate.googleapis.com/translate_a/single',
      options: Options(),
      queryParameters: {
        'client': 'gtx',
        'dt': 't',
        'sl': source,
        'tl': target,
        'q': text,
      },
    ).then((response) {
      print(response.data!);
      return text;
    }).catchError((e) {
      print(e);
    });
  }
}
