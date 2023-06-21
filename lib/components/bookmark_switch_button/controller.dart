import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class BookmarkSwitchButtonController extends GetxController {
  final int id;

  final bool isNovel;

  BookmarkSwitchButtonController(
    this.id, {
    required bool initValue,
    required this.isNovel,
  }) : _isBookmarked = initValue;

  bool _isBookmarked;

  bool _requesting = false;

  bool get isBookmarked => _isBookmarked;

  bool get requesting => _requesting;

  Restrict restrict = Restrict.public;

  Future<void> changeBookmarkState({bool isChange = false, Restrict restrict = Restrict.public}) {
    _requesting = true;
    update();

    if (isChange || !_isBookmarked) {
      return Get.find<ApiClient>().postBookmarkAdd(id, isNovel: isNovel, restrict: restrict).then((result) {
        _isBookmarked = true;
      }).catchError((e) {
        Log.e('添加书签失败', e);
      }).whenComplete(() {
        _requesting = false;
        update();
      });
    } else {
      return Get.find<ApiClient>().postBookmarkDelete(id, isNovel: isNovel).then((result) {
        _isBookmarked = false;
        update();
      }).catchError((e) {
        Log.e('删除书签失败', e);
      }).whenComplete(() {
        _requesting = false;
        update();
      });
    }
  }
}
