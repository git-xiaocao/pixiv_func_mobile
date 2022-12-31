import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'controller.dart';

class FrameGifWidget extends StatelessWidget {
  final int id;
  final String previewUrl;
  final List<ui.Image> images;
  final List<int> delays;
  final Size size;

  const FrameGifWidget({
    Key? key,
    required this.id,
    required this.previewUrl,
    required this.images,
    required this.delays,
    required this.size,
  }) : super(key: key);

  String get tag => '$id';

  @override
  Widget build(BuildContext context) {
    Get.put(FrameGifController(images, delays), tag: tag);
    return GetBuilder<FrameGifController>(
      tag: tag,
      builder: (controller) {
        return VisibilityDetector(
          key: Key('GIF-$id'),
          onVisibilityChanged: (VisibilityInfo info) {
            bool hide = info.visibleFraction == 0.0;
            if (!hide != controller.playing) {
              if (hide) {
                controller.stop();
              } else {
                controller.start();
              }
            }
          },
          child: Hero(
            tag: 'IllustHero-$id',
            child: GestureDetector(
              onTap: () => controller.pauseStateChange(),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: size,
                      painter: _GifPainter(
                        controller.images,
                        delays: controller.delays,
                        indexValueNotifier: controller.indexValueNotifier,
                        pauseValueNotifier: controller.pauseValueNotifier,
                        size: size,
                      ),
                    ),
                    Visibility(
                      visible: controller.isPause,
                      child: const Icon(Icons.play_circle_outline_outlined, size: 70),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GifPainter extends CustomPainter {
  final List<ui.Image> images;

  final List<int> delays;

  final ValueNotifier<int> indexValueNotifier;

  final ValueNotifier<bool> pauseValueNotifier;

  final Size size;

  _GifPainter(
    this.images, {
    required this.delays,
    required this.indexValueNotifier,
    required this.pauseValueNotifier,
    required this.size,
  }) : super(repaint: indexValueNotifier);

  final paintE = Paint();

  @override
  void paint(Canvas canvas, Size size) async {
    final Size imageSize = Size(
      images[indexValueNotifier.value].width.toDouble(),
      images[indexValueNotifier.value].height.toDouble(),
    );
    final Rect dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    FittedSizes fittedSizes = applyBoxFit(BoxFit.fitWidth, imageSize, dstRect.size);
    Rect inputRect = Alignment.center.inscribe(fittedSizes.source, Offset.zero & imageSize);
    Rect outputRect = Alignment.center.inscribe(fittedSizes.destination, dstRect);

    canvas.drawImageRect(images[indexValueNotifier.value], inputRect, outputRect, paintE);
    if (pauseValueNotifier.value) {
      canvas.drawRect(outputRect, Paint()..color = Get.isDarkMode ? Colors.black45 : Colors.white24);
    }
  }

  @override
  bool shouldRepaint(covariant _GifPainter oldDelegate) {
    return indexValueNotifier != oldDelegate.indexValueNotifier;
  }
}
