import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class UserAboutContent extends StatelessWidget {
  final UserDetailResult userDetail;

  const UserAboutContent({Key? key, required this.userDetail}) : super(key: key);

  Widget buildValueItem(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onLongPress: () async {
          if (value.isNotEmpty) {
            await Utils.copyToClipboard(value);
            PlatformApi.toast(I18n.copiedToClipboardHint.tr);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075, vertical: 4),
            child: TextWidget(value, fontSize: 14, isBold: true),
          ),
        ),
      ),
    );
  }

  Widget buildNameValueItem(
    String name,
    String value,
  ) {
    return InkWell(
      onLongPress: () async {
        if (value.isNotEmpty) {
          await Utils.copyToClipboard(value);
          PlatformApi.toast(I18n.copiedToClipboardHint.tr);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextWidget(name, fontSize: 14, isBold: true),
              const SizedBox(height: 4),
              TextWidget(value, fontSize: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWebUrlItem(String name, String url, IconData iconData) {
    return GestureDetector(
      onLongPress: () async {
        if (url.isNotEmpty) {
          await Utils.copyToClipboard(url);
          PlatformApi.toast(I18n.copiedToClipboardHint.tr);
        }
      },
      onTap: () async {
        if (Utils.urlIsTwitter(url)) {
          final twitterUsername = Utils.findTwitterUsernameByUrl(url);
          if (!await PlatformApi.urlLaunch('twitter://user?screen_name=$twitterUsername')) {
            PlatformApi.urlLaunch(url);
          }
        } else {
          PlatformApi.urlLaunch(url);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
              child: TextWidget(name, fontSize: 14, isBold: true),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(42), color: Get.theme.colorScheme.surface),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextWidget(url, fontSize: 14),
                    ),
                    Icon(iconData),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = userDetail.user;
    final profile = userDetail.profile;
    final workspace = userDetail.workspace;

    return NoScrollBehaviorWidget(
      child: ListView(
        children: [
          //user
          buildValueItem(user.name),
          buildNameValueItem('ID', user.id.toString()),
          buildNameValueItem(I18n.account.tr, user.account),
          //profile
          if (profile.birth.isNotEmpty) buildNameValueItem(I18n.birthday.tr, profile.birth),
          if (profile.gender.isNotEmpty)
            buildNameValueItem(I18n.gender.tr, profile.gender == 'male' ? I18n.genderMale.tr : I18n.genderFemale.tr),
          if (profile.region.isNotEmpty) buildNameValueItem(I18n.address.tr, profile.region),
          if (profile.job.isNotEmpty) buildNameValueItem(I18n.job.tr, profile.job),

          //workspace
          if (workspace.pc.isNotEmpty) buildNameValueItem(I18n.workspacePc.tr, workspace.pc),
          if (workspace.monitor.isNotEmpty) buildNameValueItem(I18n.workspaceMonitor.tr, workspace.monitor),
          if (workspace.tool.isNotEmpty) buildNameValueItem(I18n.workspaceTool.tr, workspace.tool),
          if (workspace.scanner.isNotEmpty) buildNameValueItem(I18n.workspaceScanner.tr, workspace.scanner),
          if (workspace.tablet.isNotEmpty) buildNameValueItem(I18n.workspaceTablet.tr, workspace.tablet),
          if (workspace.mouse.isNotEmpty) buildNameValueItem(I18n.workspaceMouse.tr, workspace.mouse),
          if (workspace.printer.isNotEmpty) buildNameValueItem(I18n.workspacePrinter.tr, workspace.printer),
          if (workspace.desktop.isNotEmpty) buildNameValueItem(I18n.workspaceDesktop.tr, workspace.desktop),
          if (workspace.music.isNotEmpty) buildNameValueItem(I18n.workspaceMusic.tr, workspace.music),
          if (workspace.desk.isNotEmpty) buildNameValueItem(I18n.workspaceDesk.tr, workspace.desk),
          if (workspace.chair.isNotEmpty) buildNameValueItem(I18n.workspaceChair.tr, workspace.chair),
          if (workspace.comment.isNotEmpty) buildNameValueItem(I18n.workspaceOther.tr, workspace.comment),

          //web
          if (null != profile.webpage) buildWebUrlItem(I18n.homepage, profile.webpage!, AppIcons.web),
          if (null != profile.twitterUrl) buildWebUrlItem('Twitter', profile.twitterUrl!, AppIcons.twitter),
          if (null != profile.pawooUrl) buildWebUrlItem('Pawoo', profile.pawooUrl!, AppIcons.pawoo),
          if (null != user.comment)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(I18n.introduction.tr, fontSize: 14, isBold: true),
                  HtmlRichText(user.comment!),
                ],
              ),
            )
        ],
      ),
    );
  }
}
