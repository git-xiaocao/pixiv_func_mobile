import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/pages/user/me_settings/profile/controller.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/select_button/select_button.dart';
import 'package:pixiv_func_mobile/widgets/single_picker/single_picker.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class MeProfileSettingsPage extends StatelessWidget {
  final UserDetailResult currentDetail;

  const MeProfileSettingsPage({Key? key, required this.currentDetail}) : super(key: key);

  Map<String, Publicity> get publicityItems => {
        I18n.publicityPublic.tr: Publicity.public,
        I18n.publicityPrivate.tr: Publicity.private,
        I18n.publicityMyPixiv.tr: Publicity.mypixiv,
      };

  @override
  Widget build(BuildContext context) {
    Get.put(MeProfileSettingsController(currentDetail));
    return GetBuilder<MeProfileSettingsController>(
      builder: (controller) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: ScaffoldWidget(
          title: I18n.meProfileSettingsPageTitle.tr,
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
              return Column(
                children: [
                  Flexible(
                    child: NoScrollBehaviorWidget(
                      child: ListView(
                        children: [
                          CupertinoContextMenu(
                            actions: <Widget>[
                              CupertinoContextMenuAction(
                                child: TextWidget(I18n.modify.tr, color: Theme.of(context).colorScheme.primary),
                                onPressed: () {
                                  Get.back();
                                  controller.selectProfileImage();
                                },
                              ),
                              CupertinoContextMenuAction(
                                child: TextWidget(I18n.delete.tr),
                                onPressed: () {
                                  Get.back();
                                  controller.deleteProfileImage();
                                },
                              ),
                            ],
                            child: Container(
                              //不这样点击空白区域不响应事件
                              color: Theme.of(context).colorScheme.background,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                                child: Row(
                                  children: [
                                    if (null == controller.newProfileImage)
                                      PixivAvatarWidget(
                                        controller.profileImageUrl ??
                                            controller.presetsResult!.profilePresets.defaultProfileImageUrls.medium,
                                        radius: 60,
                                      )
                                    else
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: ExtendedImage.memory(
                                          controller.newProfileImage!.bytes,
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                    const SizedBox(width: 45),
                                    TextWidget(
                                      I18n.avatar.tr,
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            previewBuilder: (
                              BuildContext context,
                              Animation<double> animation,
                              Widget child,
                            ) {
                              if (null == controller.newProfileImage) {
                                return PixivAvatarWidget(
                                  controller.profileImageUrl ?? controller.presetsResult!.profilePresets.defaultProfileImageUrls.medium,
                                  radius: 180,
                                );
                              } else {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(180),
                                  child: ExtendedImage.memory(
                                    controller.newProfileImage!.bytes,
                                    fit: BoxFit.cover,
                                    width: 180,
                                    height: 180,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: TextWidget(I18n.nickname.tr, fontSize: 16),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: controller.userNameInput,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      constraints: const BoxConstraints(maxHeight: 40),
                                      hintText: I18n.nickname.tr,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: TextWidget(I18n.homepage.tr, fontSize: 16),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: controller.webpageInput,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      constraints: const BoxConstraints(maxHeight: 40),
                                      hintText: I18n.homepage.tr,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 60,
                                  child: TextWidget('Twitter', fontSize: 16),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: controller.twitterInput,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      constraints: const BoxConstraints(maxHeight: 40),
                                      hintText: 'Twitter ID',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                SinglePicker(
                                  title: I18n.gender.tr,
                                  items: {
                                    I18n.genderMale.tr: Gender.male,
                                    I18n.genderFemale.tr: Gender.female,
                                    I18n.genderUnknown.tr: Gender.unknown,
                                  },
                                  initialValue: controller.gender,
                                  onChanged: controller.genderOnChanged,
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: TextWidget(I18n.gender.tr, fontSize: 16),
                                  ),
                                  const SizedBox(width: 10),
                                  TextWidget(controller.genderName, fontSize: 14),
                                  const Spacer(),
                                  SelectButtonWidget(
                                    items: publicityItems,
                                    value: controller.genderPublicity,
                                    onChanged: controller.genderPublicityOnChanged,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                SinglePicker<int>(
                                  title: I18n.address.tr,
                                  items: {
                                    for (final item in controller.presetsResult!.profilePresets.addresses) item.name: item.id,
                                  },
                                  initialValue: controller.addressId,
                                  onChanged: controller.addressIdOnChanged,
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: TextWidget(I18n.address.tr, fontSize: 16),
                                  ),
                                  const SizedBox(width: 10),
                                  TextWidget(controller.addressName, fontSize: 14),
                                  const Spacer(),
                                  SelectButtonWidget(
                                    items: publicityItems,
                                    value: controller.addressPublicity,
                                    onChanged: controller.addressPublicityOnChanged,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (controller.addressIsGlobal)
                            InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  SinglePicker<String>(
                                    title: I18n.country.tr,
                                    items: {
                                      for (final item in controller.presetsResult!.profilePresets.countries) item.name: item.code,
                                    },
                                    initialValue: controller.countryCode,
                                    onChanged: controller.countryCodeOnChanged,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      child: TextWidget(I18n.country.tr, fontSize: 16),
                                    ),
                                    const SizedBox(width: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: TextWidget(controller.countryName, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 25),
                          InkWell(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                helpText: I18n.birthday.tr,
                              ).then((value) {
                                if (null != value) {
                                  controller.birthdayOnChanged(value);
                                }
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        child: TextWidget(I18n.birthday.tr, fontSize: 16),
                                      ),
                                      const SizedBox(width: 10),
                                      TextWidget(controller.birthYear, fontSize: 14),
                                      const Spacer(),
                                      SelectButtonWidget(
                                        items: publicityItems,
                                        value: controller.birthYearPublicity,
                                        onChanged: controller.birthYearPublicityOnChanged,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 70),
                                      TextWidget(controller.birthMonthDay, fontSize: 14),
                                      const Spacer(),
                                      SelectButtonWidget(
                                        items: publicityItems,
                                        value: controller.birthMonthDayPublicity,
                                        onChanged: controller.birthMonthDayPublicityOnChanged,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                SinglePicker<int>(
                                  title: I18n.job.tr,
                                  items: {
                                    for (final item in controller.presetsResult!.profilePresets.jobs) item.name: item.id,
                                  },
                                  initialValue: controller.jobId,
                                  onChanged: controller.jobIdOnChanged,
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: TextWidget(I18n.job.tr, fontSize: 16),
                                  ),
                                  const SizedBox(width: 10),
                                  TextWidget(controller.jobName, fontSize: 14),
                                  const Spacer(),
                                  SelectButtonWidget(
                                    items: publicityItems,
                                    value: controller.jobPublicity,
                                    onChanged: controller.jobPublicityOnChanged,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: TextWidget(I18n.introduction.tr, fontSize: 16),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: controller.commentInput,
                                    maxLines: 10,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: I18n.introductionHint.tr,
                                      hintStyle: const TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, bottom: 35),
                    child: MaterialButton(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      minWidth: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: TextWidget(I18n.updateProfile.tr, fontSize: 18, color: Colors.white, isBold: true),
                      ),
                      onPressed: () => controller.updateProfile(),
                    ),
                  ),
                ],
              );
            }
          }(),
        ),
      ),
    );
  }
}
