import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/api/auth_client.dart';
import 'package:pixiv_func_mobile/app/api/web_api_client.dart';
import 'package:pixiv_func_mobile/app/downloader/downloader.dart';
import 'package:pixiv_func_mobile/app/services/translate_service.dart';
import 'package:pixiv_func_mobile/global_controllers/about_controller.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';
import 'package:pixiv_func_mobile/app/services/block_tag_service.dart';
import 'package:pixiv_func_mobile/app/db/history_db.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';

Future<void> initInject() async {
  await Get.putAsync(() async => await AuthClient().initSuper());
  await Get.putAsync(() async => await WebApiClient().initSuper());
  await Get.putAsync(() async => await ApiClient().initSuper(Get.find()));
  await Get.putAsync(() async => await AccountService().init());
  await Get.putAsync(() async => await SettingsService().init());
  await Get.putAsync(() async => await BlockTagService().init());

  await Get.putAsync(() => AboutController().init());

  Get.lazyPut(() => TranslateService());

  Get.lazyPut(() => Downloader());
}
