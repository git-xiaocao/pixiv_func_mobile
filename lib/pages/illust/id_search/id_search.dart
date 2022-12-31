import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/pages/illust/illust.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class IllustIdSearchPage extends StatelessWidget {
  final int id;

  const IllustIdSearchPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(IllustIdSearchController(id));
    return GetBuilder<IllustIdSearchController>(
      builder: (controller) {
        if (PageState.loading == controller.state) {
          return ScaffoldWidget(
            titleWidget: TextWidget(I18n.illustIdPageTitle.trArgs([id.toString()]), isBold: true),
            child: Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (PageState.error == controller.state) {
          return ScaffoldWidget(
            titleWidget: TextWidget(I18n.illustIdPageTitle.trArgs([id.toString()]), isBold: true),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => controller.loadData(),
              child: Container(
                alignment: Alignment.center,
                child: const TextWidget('加载失败,点击重试', fontSize: 16),
              ),
            ),
          );
        } else if (PageState.notFound == controller.state) {
          return ScaffoldWidget(
            titleWidget: TextWidget(I18n.illustIdPageTitle.trArgs([id.toString()]), isBold: true),
            child: Container(
              alignment: Alignment.center,
              child: TextWidget(I18n.illustIdNotFound.trArgs([id.toString()]), fontSize: 16),
            ),
          );
        } else {
          if (null != controller.illustDetail) {
            final illust = controller.illustDetail!.illust;
            if (Get.find<AccountService>().current!.localUser.xRestrict < illust.xRestrict) {
              return ScaffoldWidget(
                titleWidget: TextWidget(I18n.illustIdPageTitle.trArgs([id.toString()]), isBold: true),
                child: Container(
                  alignment: Alignment.center,
                  child: TextWidget(
                    I18n.illustAgeLimitHint.trArgs(
                      [
                        id.toString(),
                        illust.xRestrict == 1
                            ? 'R-18'
                            : illust.xRestrict == 2
                                ? 'R-18G'
                                : ''
                      ],
                    ),
                    fontSize: 16,
                  ),
                ),
              );
            } else {
              return IllustPage(illust: controller.illustDetail!.illust);
            }
          } else {
            return const SizedBox();
          }
        }
      },
    );
  }
}
