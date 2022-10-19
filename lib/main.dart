import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv_func_mobile/app/http.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n_translations.dart';
import 'package:pixiv_func_mobile/app/inject/inject.dart';
import 'package:pixiv_func_mobile/app/notification.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/theme/theme.dart';
import 'package:pixiv_func_mobile/global_controllers/about_controller.dart';
import 'package:pixiv_func_mobile/pages/index.dart';
import 'package:pixiv_func_mobile/services/settings_service.dart';

import 'app/asset_manifest.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initFlutterLocalNotificationsPlugin();
    await initAssetManifest();
    await Inject.init();

    initHttpOverrides();

    await I18nTranslations.loadExpansions();
  } catch (e) {
    PlatformApi.toast('初始化异常');
    return;
  }

  runApp(const App());

  Get.find<AboutController>().check();

  const storageStatus = Permission.storage;

  if (!await storageStatus.isGranted) {
    Permission.storage.request();
  }
}

DateTime? _lastPopTime;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeCodes = Get.find<SettingsService>().language.split('_');
    final theme = Get.find<SettingsService>().theme;
    return GetMaterialApp(
      defaultTransition: Transition.leftToRight,
      translations: I18nTranslations(),
      locale: Locale(localeCodes.first, localeCodes.last),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'),
        const Locale('en', 'US'),
        const Locale('ja', 'JP'),
        const Locale('ru', 'RU'),
        for (final item in I18nTranslations.expansions) item.flutterLocale
      ],
      fallbackLocale: const Locale('zh', 'CN'),
      debugShowCheckedModeBanner: false,
      title: 'Pixiv Func',
      home: WillPopScope(
        onWillPop: () async {
          if (null == _lastPopTime || DateTime.now().difference(_lastPopTime!) > const Duration(seconds: 1)) {
            _lastPopTime = DateTime.now();
            PlatformApi.toast('再按一次返回');
            return false;
          } else {
            return true;
          }
        },
        child: const IndexWidget(),
      ),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: -1 == theme
          ? ThemeMode.system
          : theme == 0
              ? ThemeMode.dark
              : ThemeMode.light,
      enableLog: false,
    );
  }
}
