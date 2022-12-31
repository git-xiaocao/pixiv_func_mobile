import 'package:get/get.dart';
import 'package:pixiv_dart_api/pixiv_web_api.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';

class WebApiClient extends GetxService with PixivWebApi {
  Future<WebApiClient> initSuper() async {
    super.init(
      targetIPGetter: () => '210.140.92.186',
      // cookieGetter: () => 'PHPSESSID=72269198_RIVzePS3y1zyfo35LBKmVrsjaa6mLq6a;',
      cookieGetter: () => Get.find<AccountService>().current?.cookie ?? '',
      cookieUpdater: (cookie) {},
    );
    return this;
  }
}
