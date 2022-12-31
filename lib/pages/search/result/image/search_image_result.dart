import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/pixiv_image/pixiv_image.dart';
import 'package:pixiv_func_mobile/models/search_image_item.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class SearchImageResultPage extends StatelessWidget {
  final Uint8List imageBytes;
  final String filename;

  const SearchImageResultPage({Key? key, required this.imageBytes, required this.filename}) : super(key: key);

  Widget buildItem(BuildContext context, SearchImageItem item) {
    final controller = Get.find<SearchImageResultController>();
    if (item.loadFailed) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.loadItem(item),
        child: const SizedBox(
          height: 180,
          child: Center(
            child: TextWidget('加载失败,点击重试', fontSize: 16),
          ),
        ),
      );
    } else if (item.loading) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (item.result.isPixivIllust) {
        return Column(
          children: [
            IllustPreviewer(illust: item.illust!, useHero: false),
            TextWidget('相似度:${item.result.similarityText}', fontSize: 20),
          ],
        );
      } else {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                if (item.result.sourceUrl != null) {
                  controller.openUrl(item.result.sourceUrl!);
                }
              },
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: PixivImageWidget(
                      item.result.imageUrl,
                      width: constraints.maxWidth,
                      fit: BoxFit.fitWidth,
                    ),
                  );
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                if (item.result.sourceUrl != null && item.result.sourceText != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          item.result.sourceText!,
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          isBold: true,
                        ),
                        TextWidget(
                          item.result.sourceUrl!,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                else
                  const TextWidget('Unknown', fontSize: 14, overflow: TextOverflow.ellipsis, isBold: true),
                //收藏按钮
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(height: 24),
                ),
              ],
            ),
            if (item.result.miscInfoList.isNotEmpty)
              Row(
                children: [
                  for (final item in item.result.miscInfoList)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => controller.openUrl(item.url),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ExtendedImage.network('https://saucenao.com/${item.imageUrl}', width: 24, height: 24),
                      ),
                    ),
                ],
              ),
            TextWidget('相似度:${item.result.similarityText}', fontSize: 20),
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SearchImageResultController(imageBytes: imageBytes, filename: filename));
    return GetBuilder<SearchImageResultController>(
      builder: (controller) => ScaffoldWidget(
        title: I18n.searchImage.tr,
        child: () {
          if (PageState.loading == controller.state) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          } else if (PageState.error == controller.state) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => controller.loadData(),
              child: Container(
                alignment: Alignment.center,
                child: const TextWidget('加载失败,点击重试', fontSize: 16),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: NoScrollBehaviorWidget(
                child: WaterfallFlow.builder(
                  gridDelegate:
                      const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
                  itemBuilder: (BuildContext context, int index) => buildItem(context, controller.list[index]),
                  itemCount: controller.list.length,
                ),
              ),
            );
          }
        }(),
      ),
    );
  }
}
