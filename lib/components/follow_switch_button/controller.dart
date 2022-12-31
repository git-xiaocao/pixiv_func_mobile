import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class FollowSwitchButtonController extends GetxController {
  final int id;

  FollowSwitchButtonController(this.id, {required bool initValue}) : _isFollowed = initValue;

  bool _isFollowed;

  bool _requesting = false;

  bool get isFollowed => _isFollowed;

  bool get requesting => _requesting;

  Restrict restrict = Restrict.public;

  void changeFollowState({bool isChange = false, Restrict restrict = Restrict.public}) {
    _requesting = true;
    update();

    if (isChange || !_isFollowed) {
      Get.find<ApiClient>().postFollowAdd(id, restrict: restrict).then((result) {
        _isFollowed = true;
      }).catchError((e) {
        Log.e('关注用户失败', e);
      }).whenComplete(() {
        _requesting = false;
        update();
      });
    } else {
      Get.find<ApiClient>().postFollowDelete(id).then((result) {
        _isFollowed = false;
        update();
      }).catchError((e) {
        Log.e('取消关注用户失败', e);
      }).whenComplete(() {
        _requesting = false;
        update();
      });
    }
  }
}
