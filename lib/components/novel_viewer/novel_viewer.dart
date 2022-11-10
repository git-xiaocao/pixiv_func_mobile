import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/components/novel_viewer/controller.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class NovelViewer extends StatelessWidget {
  final String text;
  final int id;

  const NovelViewer({Key? key, required this.text, required this.id}) : super(key: key);

  String get tag => '$id';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Get.put(NovelViewerController(text, constraints.maxWidth - 32, constraints.maxHeight - 20), tag: tag);
        return GetBuilder<NovelViewerController>(
          tag: tag,
          builder: (controller) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (TapUpDetails details) {
              if (details.globalPosition.dx < constraints.maxWidth * 0.3) {
                if (controller.hasPrevious) {
                  controller.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                }
              } else if (details.globalPosition.dx > constraints.maxWidth * 0.7) {
                if (controller.hasNext) {
                  controller.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                }
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: NoScrollBehaviorWidget(
                    child: PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: (index) {
                        if (index > controller.pageIndex) {
                          controller.nextPage();
                        } else if (index < controller.pageIndex) {
                          controller.previousPage();
                        }
                      },
                      itemCount: controller.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            alignment: Alignment.topLeft,
                            height: constraints.maxHeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final text in controller.list[index].renderTextLines)
                                  IgnorePointer(
                                    child: Text(
                                      text,
                                      style: controller.style,
                                      textDirection: TextDirection.ltr,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                TextWidget('进度:${controller.progress.toStringAsFixed(2)}%', fontSize: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
