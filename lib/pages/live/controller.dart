import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:pixiv_dart_api/vo/live_detail_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/models/m3u8.dart';
import 'package:pixiv_func_mobile/utils/custom_timer.dart';
import 'package:pixiv_live_proxy_server/pixiv_live_proxy_server.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class LiveController extends GetxController {
  final String id;

  LiveController(this.id);

  final CancelToken cancelToken = CancelToken();

  PageState state = PageState.none;

  LiveDetailResult? _liveDetailResult;

  LiveDetailResult? get liveDetail => _liveDetailResult;

  final List<M3u8> list = [];

  int currentPlay = 1;

  VideoPlayerController? vp;

  PixivLiveProxyServer? _proxyServer;

  CustomTimer? _playerStateTimer;

  Rx<Duration> playDuration = Rx(Duration.zero);

  bool _isFullScreen = false;

  bool get isFullScreen => _isFullScreen;

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  bool _isBuffering = false;

  bool get isBuffering => _isBuffering;

  bool _isFirstPlay = false;

  bool get isFirstLoading => _isFirstPlay;

  //菜单倒计时
  int _hideMenuCountCountdown = 0;

  int get hideMenuCountCountdown => _hideMenuCountCountdown;

  Timer? _hideMenuCountTimer;

  //切换分辨率
  void currentPlayOnChange(int? value) {
    if (null != value && currentPlay != value) {
      currentPlay = value;
      vp!.pause();
      vp!.dispose();
      vp = null;
      _startPlay();
      update();
    }
  }

  void toggleMenu() {
    if (_hideMenuCountCountdown > 0) {
      _hideMenuCountCountdown = 0;
      _hideMenuCountTimer?.cancel();
      _hideMenuCountTimer = null;
    } else {
      _hideMenuCountCountdown = 6;
      _hideMenuCountTimer?.cancel();
      _hideMenuCountTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _hideMenuCountCountdown--;
        if (_hideMenuCountCountdown == 0) {
          _hideMenuCountTimer?.cancel();
          _hideMenuCountTimer = null;
        }
      });
    }
    update();
  }

  void toggleFullScreen() async {
    _isFullScreen = !_isFullScreen;
    if (_isFullScreen) {
      await AutoOrientation.landscapeLeftMode();
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await AutoOrientation.portraitUpMode();
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    update();
  }

  void togglePlay() {
    if (vp!.value.isPlaying) {
      _isPlaying = false;
      vp!.pause();
    } else {
      _isPlaying = true;
      vp!.play();
    }
    update();
  }

  void loadData() {
    state = PageState.loading;
    update();
    Get.find<ApiClient>().getLiveDetail(id, cancelToken: cancelToken).then((result) async {
      _liveDetailResult = result;

      await initPlayer(result.data.owner.hlsMovie.url);
      state = PageState.complete;
    }).catchError((e) {
      if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
        state = PageState.notFound;
      } else {
        state = PageState.error;
      }
      print(e);
    }).whenComplete(() {
      update();
    });
  }

  Future<void> initPlayer(String url) async {
    final uri = Uri.parse(url);
    _proxyServer = PixivLiveProxyServer(url: url, port: 55555, serverIp: '210.140.92.212');
    _proxyServer!.listen();

    final m3u8String = await Dio()
        .get<String>(url.replaceFirst('${uri.scheme}://${uri.host}', 'http://127.0.0.1:55555'))
        .then((response) => response.data!);

    list.addAll(M3u8.parse(m3u8String));
    await _startPlay();
    _playerStateTimer = CustomTimer(const Duration(seconds: 1), _playStateRefresher);
  }

  Future<void> _startPlay() {
    _isFirstPlay = true;
    update();
    vp = VideoPlayerController.contentUri(list[currentPlay].uri);
    return vp!.initialize().whenComplete(() async {
      vp!.addListener(() async {
        if (null != vp) {
          if (vp!.value.hasError) {
            PlatformApi.toast('Error:${vp!.value.errorDescription}');
            vp!.dispose();
            vp == null;
            _startPlay();
            return;
          }
          bool needUpdate = false;
          if (_isPlaying != vp!.value.isPlaying) {
            _isPlaying = vp!.value.isPlaying;
            needUpdate = true;
          }
          if (_isBuffering != vp!.value.isBuffering) {
            _isBuffering = vp!.value.isBuffering;
            needUpdate = true;
          }
          if (needUpdate) {
            update();
          }
        }
      });
      return vp!.play().whenComplete(() {
        _isPlaying = true;
        _isFirstPlay = false;
        update();
      });
    });
  }

  Future<void> _playStateRefresher() async {
    if (null != vp) {
      //正在播放且不在缓冲
      if (vp!.value.isPlaying && !vp!.value.isBuffering) {
        playDuration.value += const Duration(seconds: 1);
      }
    }
  }

  //格式化 播放时长
  String formatPlayDuration(Duration duration) {
    final hour = duration.inHours;
    final minute = duration.inMinutes - hour * 60;
    final second = duration.inSeconds - hour * 60 * 60 - minute * 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }

  @override
  void onInit() {
    loadData();

    Wakelock.enable();
    super.onInit();
  }

  @override
  void onClose() {
    cancelToken.cancel();
    vp?.dispose();
    _playerStateTimer?.cancel();
    _proxyServer?.close();
    _playerStateTimer?.cancel();
    Wakelock.disable();
    super.onClose();
  }
}
