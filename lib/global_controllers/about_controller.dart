import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/app/updater/updater.dart';
import 'package:pixiv_func_mobile/models/release_info.dart';
import 'package:pixiv_func_mobile/pages/about/about.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class AboutController extends GetxController implements GetxService {
  static const _authorGitHubUrl = 'https://github.com/git-xiaocao';

  static const _repoName = 'pixiv_func_mobile';

  static const _helpUrl = 'https://pixiv.xiaocao.moe/#/pixiv-func/mobile';

  PageState _state = PageState.none;

  PageState get state => _state;

  bool _first = true;

  int? _latestReleaseVersionCode;

  late String _appVersionName;

  late int _appVersionCode;

  String? get appVersion => _appVersionName;

  ReleaseInfo? releaseInfo;

  bool? get hasNewVersion => _latestReleaseVersionCode == null ? null : _appVersionCode < _latestReleaseVersionCode!;

  Future<void> loadData() async {
    releaseInfo = null;
    _state = PageState.loading;
    update();
    await Dio().get<String>("https://api.github.com/repos/git-xiaocao/pixiv_func_mobile/releases/latest").then((result) {
      final Map<String, dynamic> json = jsonDecode(result.data!);
      if (null == json['assets']) {
        PlatformApi.toast('有新版本,但是小草忘记上传文件');
        _state = PageState.error;
        return;
      }
      final assets = (json['assets'] as List<dynamic>);

      releaseInfo = ReleaseInfo(
        htmlUrl: json['html_url'],
        tagName: json['tag_name'],
        name: json['name'],
        body: json['body'] as String,
        assets: [
          for (final asset in assets)
            ReleaseAsset(
              updatedAt: asset['updated_at'],
              browserDownloadUrl: asset['browser_download_url'],
            ),
        ],
      );
      _latestReleaseVersionCode = int.parse(releaseInfo!.tagName.split('+').last);
      _state = PageState.none;
    }).catchError((e, s) {
      Log.e('获取最新发行版信息失败');
      _state = PageState.error;
    }).whenComplete(() {
      update();
    });
  }

  Future<void> updateApp() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final assets = releaseInfo!.assets;
    final abi = androidInfo.supportedAbis.first!;
    final asset = assets.firstWhere((asset) => asset.browserDownloadUrl.contains(abi));
    return Updater.startUpdate('https://ghproxy.com/${asset.browserDownloadUrl}', _appVersionName);
  }

  void action(int index) {
    switch (index) {
      case 0:
        openUrlByBrowser(_authorGitHubUrl);
        break;
      case 1:
        openUrlByBrowser(_helpUrl);
        break;
      case 2:
        openUrlByBrowser('$_authorGitHubUrl/$_repoName/releases/$_appVersionName+$_appVersionCode');
        break;
      case 3:
        openUrlByBrowser('$_authorGitHubUrl/$_repoName');
        break;
    }
  }

  void openUrlByBrowser(String url) {
    PlatformApi.urlLaunch(url);
  }

  Future<AboutController> init() async {

    _appVersionName = await PlatformApi.appVersionName;
    _appVersionCode = await PlatformApi.appVersionCode;
    return this;
  }

  void check() {
    loadData().then((_) {
      if (true == hasNewVersion) {
        if (_first) {
          Get.snackbar(
            I18n.versionUpdate.tr,
            I18n.versionUpdateHint.trArgs([appVersion!,releaseInfo!.name]),
            duration: const Duration(seconds: 6),
            onTap: (snack) => Get.to(() => const AboutPage()),
          );
          _first = false;
        }
      }
    });
  }
}
