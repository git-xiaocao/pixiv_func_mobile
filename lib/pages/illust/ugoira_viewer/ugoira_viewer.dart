import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/components/frame_gif/frame_gif.dart';
import 'package:pixiv_func_mobile/components/pixiv_image/pixiv_image.dart';

import 'controller.dart';

class UgoiraViewer extends StatelessWidget with RouteAware {
  final int id;
  final String previewUrl;

  @override
  void didPopNext() {}

  const UgoiraViewer({
    Key? key,
    required this.id,
    required this.previewUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tag = '$runtimeType-$id';
    Get.put(UgoiraViewerController(id), tag: tag);

    return GetBuilder<UgoiraViewerController>(
      tag: tag,
      builder: (UgoiraViewerController controller) {
        final state = controller.state;
        return state.init
            ? FrameGifWidget(
                id: id,
                previewUrl: previewUrl,
                images: state.images,
                delays: state.delays,
                size: state.size,
              )
            : GestureDetector(
                onTap: () => controller.play(),
                child: Hero(
                  tag: 'IllustHero-$id',
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: PixivImageWidget(
                          previewUrl,
                          color: Get.isDarkMode ? Colors.black45 : Colors.white24,
                          colorBlendMode: BlendMode.srcOver,
                          placeholderWidget: const SizedBox(
                            height: 180,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      state.loading ? const CircularProgressIndicator() : const Icon(Icons.play_circle_outline_outlined, size: 70),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
