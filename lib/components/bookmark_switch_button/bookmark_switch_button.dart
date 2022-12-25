import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/widgets/select_button/select_button.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class BookmarkSwitchButton extends StatelessWidget {
  final int id;
  final String title;
  final bool initValue;
  final bool isNovel;
  final bool isButton;

  const BookmarkSwitchButton({
    Key? key,
    required this.id,
    required this.title,
    required this.initValue,
    this.isNovel = false,
    this.isButton = true,
  }) : super(key: key);

  String get tag => '$id';

  void _restrictDialog() {
    final controller = Get.find<BookmarkSwitchButtonController>(tag: tag);
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          color: Get.theme.colorScheme.background,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height * 0.35, minHeight: Get.height * 0.35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: TextWidget(isNovel ? I18n.bookmarkNovel.tr : I18n.bookmarkIllust.tr, fontSize: 18, isBold: true),
                    ),
                    ObxValue<Rx<Restrict>>(
                      (data) => SelectButtonWidget(
                        items: {
                          I18n.restrictPublic.tr: Restrict.public,
                          I18n.restrictPrivate.tr: Restrict.private,
                        },
                        value: data.value,
                        onChanged: (Restrict? value) {
                          if (null != value) {
                            data.value = value;
                            controller.restrict = value;
                          }
                        },
                      ),
                      controller.restrict.obs,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(title, fontSize: 16),
                    TextWidget('$id', fontSize: 12),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        elevation: 0,
                        color: Get.theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide.none,
                        ),
                        minWidth: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TextWidget(I18n.cancel.tr, fontSize: 18, color: Colors.white, isBold: true),
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: MaterialButton(
                        elevation: 0,
                        color: Get.theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        minWidth: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TextWidget(I18n.confirm.tr, fontSize: 18, color: Colors.white, isBold: true),
                        ),
                        onPressed: () async {
                          controller.changeBookmarkState(isChange: true, restrict: controller.restrict);
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isRootController = !Get.isRegistered<BookmarkSwitchButtonController>(tag: tag);
    if (isRootController) {
      Get.put(BookmarkSwitchButtonController(id, initValue: initValue, isNovel: isNovel), tag: tag);
    }

    return GetBuilder<BookmarkSwitchButtonController>(
      tag: tag,
      dispose: (state) {
        if (isRootController) {
          Get.delete<BookmarkSwitchButtonController>(tag: tag);
        }
      },
      builder: (controller) {
        if (controller.requesting) {
          return Padding(
            padding: EdgeInsets.all(isButton ? 12 : 8),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: CupertinoActivityIndicator(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          );
        } else {
          if (isButton) {
            return GestureDetector(
              onLongPress: () => controller.requesting || controller.isBookmarked ? null : _restrictDialog(),
              child: IconButton(
                splashRadius: 24,
                iconSize: 24,
                onPressed: () => controller.changeBookmarkState(),
                icon: controller.isBookmarked
                    ? Icon(
                        Icons.favorite_sharp,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : const Icon(Icons.favorite_outline_sharp),
              ),
            );
          } else {
            return GestureDetector(
              onLongPress: () => controller.requesting || controller.isBookmarked ? null : _restrictDialog(),
              onTap: () => controller.changeBookmarkState(),
              child: controller.isBookmarked
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.favorite_sharp,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.favorite_outline_sharp, size: 24),
                    ),
            );
          }
        }
      },
    );
  }
}
