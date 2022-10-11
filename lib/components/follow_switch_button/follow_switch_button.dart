import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/select_button/select_button.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class FollowSwitchButton extends StatelessWidget {
  final int id;
  final String userName;
  final String userAccount;
  final bool initValue;

  const FollowSwitchButton({
    Key? key,
    required this.id,
    required this.userName,
    required this.userAccount,
    required this.initValue,
  }) : super(key: key);

  String get controllerTag => '$runtimeType-$id';

  void _restrictDialog() {
    final controller = Get.find<FollowSwitchButtonController>(tag: controllerTag);

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
                      child: TextWidget(I18n.followUser.tr, fontSize: 18, isBold: true),
                    ),
                    ObxValue<Rx<Restrict>>(
                      (data) => SelectButtonWidget(
                        items: {
                          I18n.restrictPublic.tr: Restrict.public,
                          I18n.restrictPrivate: Restrict.private,
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
                    TextWidget(userName, fontSize: 16),
                    TextWidget(userAccount, fontSize: 12),
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
                          controller.changeFollowState(isChange: true, restrict: controller.restrict);
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
    final bool isRootController = !Get.isRegistered<FollowSwitchButtonController>(tag: controllerTag);
    if (isRootController) {
      Get.put(FollowSwitchButtonController(id, initValue: initValue), tag: controllerTag);
    }

    return GetBuilder<FollowSwitchButtonController>(
      tag: controllerTag,
      dispose: (state) {
        if (isRootController) {
          Get.delete<FollowSwitchButtonController>(tag: controllerTag);
        }
      },
      builder: (controller) {
        final width = max(Utils.getTextSize(text: I18n.follow.tr).width, Utils.getTextSize(text: I18n.followed.tr).width) + 40;
        return SizedBox(
          width: width,
          height: 45,
          child: controller.requesting
              ? SizedBox(
                  width: width,
                  height: 45,
                  child: Center(
                    child: CupertinoActivityIndicator(color: Theme.of(context).colorScheme.onSurface),
                  ),
                )
              : controller.isFollowed
                  ? MaterialButton(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      onPressed: () => controller.changeFollowState(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextWidget(I18n.followed.tr, color: Theme.of(context).colorScheme.onSurface, isBold: true),
                      ),
                    )
                  : MaterialButton(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      onPressed: () => controller.changeFollowState(),
                      onLongPress: () => _restrictDialog(),
                      child: Center(
                        child: TextWidget(I18n.follow.tr, color: Colors.white, isBold: true),
                      ),
                    ),
        );
      },
    );
  }
}
