import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/translate/google.dart';
import 'package:pixiv_func_mobile/app/translate/translate_base.dart';

class TranslateService extends GetxService {
  final translates = [
    GoogleTranslate(),
  ];

  TranslateBase get current => translates.first;
}
