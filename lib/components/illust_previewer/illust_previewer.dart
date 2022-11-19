import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/components/bookmark_switch_button/bookmark_switch_button.dart';
import 'package:pixiv_func_mobile/components/pixiv_image/pixiv_image.dart';
import 'package:pixiv_func_mobile/pages/illust/illust.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class IllustPreviewer extends StatelessWidget {
  final Illust illust;

  final bool square;

  final bool showUserName;

  final bool useHero;

  final BorderRadius? borderRadius;

  const IllustPreviewer({
    Key? key,
    required this.illust,
    this.square = false,
    this.showUserName = true,
    required this.useHero,
    this.borderRadius,
  }) : super(key: key);

  Widget buildImage({
    required String url,
    required double width,
    required double height,
    BorderRadius? borderRadius,
    bool needHero = false,
  }) {
    final widget = PixivImageWidget(
      url,
      width: width,
      height: height,
      fit: square ? BoxFit.fill : BoxFit.fitWidth,
      imageBuilder: (Widget imageWidget) {
        return Stack(
          fit: StackFit.expand,
          children: [
            if (needHero && useHero)
              Hero(
                tag: 'IllustHero-${illust.id}',
                child: imageWidget,
              )
            else
              imageWidget,
            if (illust.isR18)
              //左上
              Positioned(
                left: 7,
                top: 7,
                child: Card(
                  color: Get.theme.colorScheme.primary,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    child: TextWidget('R-18', color: Colors.white),
                  ),
                ),
              ),
            if (illust.isUgoira)
              //左下
              Positioned(
                left: 7,
                bottom: 7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0x99343838),
                  ),
                  child: const Icon(Icons.gif_box_outlined, color: Colors.white, size: 30),
                ),
              ),
            if (illust.pageCount > 1)
              //右上
              Positioned(
                right: 7,
                top: 7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    color: const Color(0x99343838),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextWidget('${illust.pageCount}', color: Colors.white),
                  ),
                ),
              ),
            if (illust.isAi)
              //右下
              Positioned(
                right: 7,
                bottom: 7,
                child: Card(
                  color: Get.theme.colorScheme.error,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    child: TextWidget('AI', color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (illust.restrict == 0) {
          Get.to(() => IllustPage(illust: illust), routeName: 'Illust-${illust.id}', preventDuplicates: false);
        } else {
          PlatformApi.toast(I18n.setToPrivate.tr);
        }
      },
      child: borderRadius != null
          ? ClipRRect(
              borderRadius: borderRadius,
              child: widget,
            )
          : widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (square) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return buildImage(
            url: illust.imageUrls.squareMedium,
            width: constraints.maxWidth,
            height: constraints.maxWidth,
            borderRadius: borderRadius,
          );
        },
      );
    } else {
      return Column(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final previewHeight = constraints.maxWidth / illust.width * illust.height;
              return buildImage(
                url: Get.find<SettingsService>().getPreviewUrl(illust.imageUrls),
                width: constraints.maxWidth,
                height: previewHeight,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                needHero: true,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      illust.title,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      isBold: true,
                    ),
                    if (showUserName)
                      TextWidget(
                        illust.user.name,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              BookmarkSwitchButton(
                id: illust.id,
                title: illust.title,
                initValue: illust.isBookmarked,
              ),
            ],
          ),
        ],
      );
    }
  }
}
