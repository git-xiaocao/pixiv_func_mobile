import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_func_mobile/components/bookmark_switch_button/bookmark_switch_button.dart';
import 'package:pixiv_func_mobile/components/pixiv_image/pixiv_image.dart';
import 'package:pixiv_func_mobile/pages/novel/novel.dart';
import 'package:pixiv_func_mobile/widgets/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class NovelPreviewer extends StatelessWidget {
  final Novel novel;
  final bool showUserName;

  const NovelPreviewer({Key? key, required this.novel, this.showUserName = true}) : super(key: key);

  static const heightRatio = 248 / 176;

  @override
  Widget build(BuildContext context) {
    final sb = StringBuffer();
    final textCountString = novel.textLength.toString().replaceAllMapped(
      RegExp(r'\B(?=(?:\d{3})+\b)'),
      (match) {
        return ',${match.input.substring(match.start, match.end)}';
      },
    );
    sb.write('$textCountString字 ');
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height * 0.6),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: NoScrollBehaviorWidget(
                          child: ListView(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(novel.title, fontSize: 16, isBold: true),
                                        const SizedBox(height: 8),
                                        if (showUserName) TextWidget(novel.user.name, fontSize: 10, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                  BookmarkSwitchButton(
                                    id: novel.id,
                                    title: novel.title,
                                    initValue: novel.isBookmarked,
                                    isNovel: true,
                                    isButton: true,
                                  ),
                                ],
                              ),
                              TextWidget(sb.toString(), fontSize: 10, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(height: 4),
                              Wrap(
                                runSpacing: 5,
                                spacing: 5,
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  for (final tag in novel.tags)
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).colorScheme.surface,
                                      ),
                                      child: TextWidget('${tag.name}${tag.translatedName != null ? ' ${tag.translatedName}' : ''}',
                                          fontSize: 12, forceStrutHeight: true),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              HtmlRichText(novel.caption),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: MaterialButton(
                          elevation: 0,
                          color: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          minWidth: double.infinity,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: TextWidget('阅读', fontSize: 18, color: Colors.white, isBold: true),
                          ),
                          onPressed: () {
                            Get.back();
                            Get.to(() => NovelPage(novel: novel));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxWidth * 0.3 * heightRatio,
              child: Row(
                children: [
                  SizedBox(
                    width: constraints.maxWidth * 0.3,
                    height: constraints.maxWidth * 0.3 * heightRatio,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        child: PixivImageWidget(
                          novel.imageUrls.medium,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    // width: constraints.maxWidth * 0.7 - 12,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(novel.title, fontSize: 16, isBold: true, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  if (showUserName) TextWidget(novel.user.name, fontSize: 10, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            BookmarkSwitchButton(
                              id: novel.id,
                              title: novel.title,
                              initValue: novel.isBookmarked,
                              isNovel: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        TextWidget(sb.toString(), fontSize: 10, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Wrap(
                            runSpacing: 5,
                            spacing: 5,
                            clipBehavior: Clip.hardEdge,
                            children: [
                              for (final tag in novel.tags)
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                  child: TextWidget(
                                    '${tag.name}${tag.translatedName != null ? ' ${tag.translatedName}' : ''}',
                                    fontSize: 12,
                                    forceStrutHeight: true,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
