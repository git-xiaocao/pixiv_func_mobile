import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/auth_client.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/models/account.dart';
import 'package:pixiv_func_mobile/pages/home/home.dart';
import 'package:pixiv_func_mobile/pages/illust/id_search/id_search.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class UrlScheme {
  static Future<void> handler(String url) async {
    final uri = Uri.parse(url);
    if ('account' == uri.host) {
      _login(uri);
    } else {
      _content(uri);
    }
  }

  static void _content(Uri uri) {
    if (Get.find<AccountService>().isEmpty) {
      PlatformApi.toast(I18n.loginRequired.tr);
      return;
    }
    if ('http' == uri.scheme || 'https' == uri.scheme) {
      if (uri.host.contains('pixiv.net')) {
        final pathSegments = uri.pathSegments;
        //  u/$id
        if (pathSegments.contains('u') && pathSegments.indexOf('u') <= pathSegments.length - 2) {
          int index = pathSegments.indexOf('u');
          final idString = uri.pathSegments[index + 1];
          final id = int.tryParse(idString);
          if (id == null) {
            PlatformApi.toast(I18n.invalidId.trArgs([idString]));
            return;
          }
          Get.to(() => UserPage(id: id));
        } else
        //  i/$id
        if (pathSegments.contains('i') && pathSegments.indexOf('i') <= pathSegments.length - 2) {
          int index = pathSegments.indexOf('i');
          final idString = uri.pathSegments[index + 1];
          final id = int.tryParse(idString);
          if (id == null) {
            PlatformApi.toast(I18n.invalidId.trArgs([idString]));
            return;
          }
          Get.to(() => IllustIdSearchPage(id: id));
        } else if (pathSegments.contains('users') && pathSegments.indexOf('users') <= pathSegments.length - 2) {
          int index = pathSegments.indexOf('users');
          final idString = uri.pathSegments[index + 1];
          final id = int.tryParse(idString);
          if (id == null) {
            PlatformApi.toast(I18n.invalidId.trArgs([idString]));
            return;
          }
          Get.to(() => UserPage(id: id));
        } else if (pathSegments.contains('artworks') && pathSegments.indexOf('artworks') <= pathSegments.length - 2) {
          int index = pathSegments.indexOf('artworks');
          final idString = uri.pathSegments[index + 1];
          final id = int.tryParse(idString);
          if (id == null) {
            PlatformApi.toast(I18n.invalidId.trArgs([idString]));
            return;
          }
          Get.to(() => IllustIdSearchPage(id: id));
        } else if (uri.queryParameters['illust_id'] != null) {
          final idString = uri.queryParameters['illust_id'] as String;
          final id = int.tryParse(idString);
          if (id == null) {
            PlatformApi.toast(I18n.invalidId.trArgs([idString]));
            return;
          }
          Get.to(() => IllustIdSearchPage(id: id));
        } else if (uri.queryParameters['id'] != null) {
          if (uri.path.contains('novel')) {
            PlatformApi.toast('小说暂未支持');
          } else {
            final idString = uri.queryParameters['id'] as String;

            final id = int.tryParse(idString);
            if (id == null) {
              PlatformApi.toast(I18n.invalidId.trArgs([idString]));
              return;
            }
            Get.to(() => UserPage(id: id));
          }
        } else {
          PlatformApi.toast(I18n.invalidId.trArgs([uri.path]));
        }
      }
    } else if ("pixiv" == uri.scheme) {
      if ('illusts' == uri.host) {
        final idString = uri.pathSegments.last;
        final id = int.tryParse(idString);
        if (id == null) {
          PlatformApi.toast(I18n.invalidId.trArgs([idString]));
          return;
        }
        Get.to(() => IllustIdSearchPage(id: id));
      } else if ('users' == uri.host) {
        final idString = uri.pathSegments.last;
        final id = int.tryParse(idString);
        if (id == null) {
          PlatformApi.toast(I18n.invalidId.trArgs([idString]));
          return;
        }
        Get.to(() => UserPage(id: id));
      }
    }else if ("pixivfunc" == uri.scheme) {
      if ('illusts' == uri.host) {
        final idString = uri.pathSegments.last;
        final id = int.tryParse(idString);
        if (id == null) {
          PlatformApi.toast(I18n.invalidId.trArgs([idString]));
          return;
        }
        Get.to(() => IllustIdSearchPage(id: id));
      } else if ('users' == uri.host) {
        final idString = uri.pathSegments.last;
        final id = int.tryParse(idString);
        if (id == null) {
          PlatformApi.toast(I18n.invalidId.trArgs([idString]));
          return;
        }
        Get.to(() => UserPage(id: id));
      }
    }
  }

  static void _login(Uri uri) {
    if ('account' == uri.host) {
      final SettingsService settingsService = Get.find();
      final AccountService accountService = Get.find();
      final AuthClient authClient = Get.find();
      authClient.initAccountAuthToken(uri.queryParameters['code'] as String).then((result) {
        Log.i(result);

        PlatformApi.toast(I18n.loginSuccess.tr);

        final firstAccount = accountService.isEmpty;

        accountService.add(Account(null, result));
        settingsService.guideInit = true;

        if (firstAccount) {
          Get.offAll(const HomePage());
        } else {
          Get.back();
        }
      }).catchError((e) {
        Log.e('登录失败', e);
      });
    }
  }
}
