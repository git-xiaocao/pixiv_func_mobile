import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';

class PixivImageWidget extends StatelessWidget {
  final String url;

  final Color? color;

  final BlendMode? colorBlendMode;

  final double? width;

  final double? height;

  final BoxFit? fit;

  final Widget Function(Widget imageWidget)? imageBuilder;

  final Widget? placeholderWidget;

  final String? host;

  const PixivImageWidget(
    this.url, {
    Key? key,
    this.color,
    this.colorBlendMode,
    this.width,
    this.height,
    this.fit,
    this.imageBuilder,
    this.placeholderWidget,
    this.host,
  }) : super(key: key);

  static const _defaultHost = 'i.pximg.net';

  @override
  Widget build(BuildContext context) {
    //转义 不然 '/' 被当成路径会报错
    final cacheUrlPath = Uri.parse(url).path.replaceAll('/', '%2F');
    return ExtendedImage.network(
      Get.find<SettingsService>().toCurrentImageSource(url, host ?? _defaultHost),
      headers: const {'Referer': 'https://app-api.pixiv.net/'},
      cacheKey: cacheUrlPath,
      printError: false,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return placeholderWidget ??
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(child: CircularProgressIndicator()),
                );
          case LoadState.completed:
            return imageBuilder?.call(state.completedWidget);
          case LoadState.failed:
            return Center(
              child: IconButton(
                icon: const Icon(Icons.refresh_sharp),
                iconSize: 35,
                onPressed: state.reLoadImage,
              ),
            );
        }
      },
      color: color,
      colorBlendMode: colorBlendMode,
      enableMemoryCache: false,
      width: width,
      height: height,
      fit: fit ?? BoxFit.fitWidth,
    );
  }
}
