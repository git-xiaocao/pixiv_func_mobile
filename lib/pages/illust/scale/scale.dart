import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';

class ImageScalePage extends StatelessWidget {
  final Illust illust;
  final int initialPage;

  const ImageScalePage({Key? key, required this.illust, this.initialPage = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final urls = <String>[];
    if (1 == illust.pageCount) {
      urls.add(
        Get.find<SettingsService>().scaleQuality ? illust.metaSinglePage.originalImageUrl! : illust.imageUrls.large,
      );
    } else {
      urls.addAll(
        [
          for (final metaPage in illust.metaPages)
            Get.find<SettingsService>().scaleQuality ? metaPage.imageUrls.original! : metaPage.imageUrls.large
        ],
      );
    }
    return ObxValue<RxInt>(
      (data) {
        return ScaffoldWidget(
          title: '${data.value + 1}/${urls.length}',
          child: ExtendedImageGesturePageView(
            controller: ExtendedPageController(initialPage: initialPage),
            onPageChanged: (int page) => data.value = page,
            children: [
              for (int i = 0; i < urls.length; ++i)
                ExtendedImage.network(
                  Get.find<SettingsService>().toCurrentImageSource(urls[i]),
                  headers: const {'Referer': 'https://app-api.pixiv.net'},
                  gaplessPlayback: true,
                  mode: ExtendedImageMode.gesture,
                  loadStateChanged: (ExtendedImageState state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return null;
                  },
                  initGestureConfigHandler: (ExtendedImageState state) => GestureConfig(
                    minScale: 0.9,
                    maxScale: 6.0,
                    speed: 1.0,
                    initialScale: 0.95,
                    inPageView: true,
                  ),
                ),
            ],
          ),
        );
      },
      initialPage.obs,
    );
  }
}
