import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/api/web_api_client.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';

class MeWebSettingsController extends GetxController {
  final UserDetailResult currentDetail;

  MeWebSettingsController(this.currentDetail);

  final AccountService _accountService = Get.find();
  final WebApiClient _webApiClient = Get.find();

  int _restrict = 0;

  int get restrict => _restrict;

  String? _postKey;

  @override
  void onInit() {
    _restrict = _accountService.current!.localUser.xRestrict;
    initPostKey();
    super.onInit();
  }

  Future<void> initPostKey() async {
    await _webApiClient.getPostKey().then((value) {
      _postKey = value;
    }).catchError((e) {
      PlatformApi.toast(I18n.initPostKeyFailed.tr);
    });
  }

  void restrictOnChange(int? value) async {
    if (null != value) {
      if (value != 0) {
        final birthday = currentDetail.profile.birth.isNotEmpty ? DateTime.parse(currentDetail.profile.birth) : DateTime.now();
        //小于18岁
        if (birthday.isAfter(DateTime.now().subtract(const Duration(days: 18 * 365)))) {
          PlatformApi.toast(I18n.ageLimitHint.tr);
          return;
        }
      }
      if (_postKey == null) {
        await initPostKey();
      }
      _webApiClient.postSetUserRestrict(restrict: value, postKey: _postKey!).then((_) {
        _restrict = value;
        update();
        _accountService.updateUserAccount(_accountService.current!.userAccount..user.xRestrict = value);
      }).catchError((e) {
        PlatformApi.toast(I18n.webSettingFailed.tr);
      });
    }
  }
}
