import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class BlockTagPage extends StatelessWidget {
  const BlockTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BlockTagController());
    return GetBuilder<BlockTagController>(
      builder: (controller) => ScaffoldWidget(
        title: I18n.blockTagPageTitle.tr,
        child: NoScrollBehaviorWidget(
          child: ListView(
            children: [
              for (final tag in controller.list)
                ListTile(
                  onTap: () => controller.blockTagChangeState(tag),
                  title: TextWidget(tag.name, fontSize: 16),
                  subtitle: tag.translatedName != null ? TextWidget(tag.translatedName!, fontSize: 12) : null,
                  trailing: Icon(
                    AppIcons.blocked,
                    size: 25,
                    color: controller.blockTagService.isBlocked(tag) ? Get.theme.colorScheme.primary : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
