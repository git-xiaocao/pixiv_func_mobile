import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/comment.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/app/services/translate_service.dart';

class CommentItemController extends GetxController {
  final Comment comment;

  CommentItemController(this.comment);

  bool _loading = false;

  bool get loading => _loading;

  String? _translateText;

  String? get translateText => _translateText;

  void onTranslate() {
    _loading = true;
    update();
    Get.find<TranslateService>()
        .current
        .translationText(text: comment.comment, source: null, target: Get.find<SettingsService>().language)
        .then((result) {
      _translateText = result;
      _loading = false;
      update();
    }).catchError((e) {
      PlatformApi.toast('Translate failed');
      _loading = false;
      update();
    });
  }
}
