import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/widgets/auto_keep/auto_keep.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';

import 'controller.dart';
import 'everyone/eyeryone.dart';
import 'follow/follow.dart';
import 'my_pixiv/my_pixiv.dart';

class NewPage extends StatefulWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Get.put(NewController(this));
    return GetBuilder<NewController>(
      builder: (controller) => ScaffoldWidget(
        titleWidget: TabBarWidget(
          onTap: controller.tabOnTap,
          isScrollable: true,
          controller: controller.tabController,
          indicatorMinWidth: 15,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
          indicator: const RRecTabIndicator(
            radius: 4,
            insets: EdgeInsets.only(bottom: 5),
          ),
          tabs: [
            TabWidget(
              text: I18n.following.tr,
              icon: controller.tabController.index == 0
                  ? controller.expandTypeSelector
                      ? const Icon(Icons.keyboard_arrow_up, size: 12)
                      : const Icon(Icons.keyboard_arrow_down, size: 12)
                  : null,
              iconSize: 12,
              inScrolls: true,
            ),
            TabWidget(
              text: I18n.everyone.tr,
              icon: controller.tabController.index == 1
                  ? controller.expandTypeSelector
                      ? const Icon(Icons.keyboard_arrow_up, size: 12)
                      : const Icon(Icons.keyboard_arrow_down, size: 12)
                  : null,
              iconSize: 12,
              inScrolls: true,
            ),
            TabWidget(
              text: I18n.myPixiv.tr,
              icon: controller.tabController.index == 2
                  ? controller.expandTypeSelector
                      ? const Icon(Icons.keyboard_arrow_up, size: 12)
                      : const Icon(Icons.keyboard_arrow_down, size: 12)
                  : null,
              iconSize: 12,
              inScrolls: true,
            ),
          ],
        ),
        child: TabBarView(
          controller: controller.tabController,
          children: [
            AutoKeepWidget(
              child: FollowNewContent(expandTypeSelector: controller.expandTypeSelector),
            ),
            AutoKeepWidget(
              child: EveryoneNewContent(expandTypeSelector: controller.expandTypeSelector),
            ),
            AutoKeepWidget(
              child: MyPixivNewContent(expandTypeSelector: controller.expandTypeSelector),
            ),
          ],
        ),
      ),
    );
  }
}
