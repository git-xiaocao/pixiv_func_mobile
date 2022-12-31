import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/widgets/select_button/select_button.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class MeWebSettingsPage extends StatelessWidget {
  final UserDetailResult currentDetail;

  const MeWebSettingsPage({Key? key, required this.currentDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MeWebSettingsController(currentDetail));
    return GetBuilder<MeWebSettingsController>(
      builder: (controller) => ScaffoldWidget(
        title: I18n.meWebSettingsPageTitle.tr,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
              child: Row(
                children: [
                  TextWidget(I18n.ageLimit.tr, fontSize: 16),
                  const Spacer(),
                  SelectButtonWidget(
                    items: {
                      I18n.allAge.tr: 0,
                      'R-18': 1,
                      'R-18G': 2,
                    },
                    value: controller.restrict,
                    onChanged: controller.restrictOnChange,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
