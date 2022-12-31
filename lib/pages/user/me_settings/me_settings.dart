import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/user/controller.dart';
import 'package:pixiv_func_mobile/pages/user/me_settings/profile/profile.dart';
import 'package:pixiv_func_mobile/pages/user/me_settings/web/web.dart';
import 'package:pixiv_func_mobile/pages/user/me_settings/workspace/workspace.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class MeSettingsPage extends StatelessWidget {
  const MeSettingsPage({Key? key}) : super(key: key);

  Widget buildItem({required VoidCallback onTap, required String title}) {
    return ListTile(
      onTap: onTap,
      title: TextWidget(title, fontSize: 16, isBold: true),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: I18n.meSettingsPageTitle.tr,
      child: Column(
        children: [
          buildItem(
            onTap: () => Get.to(() => MeProfileSettingsPage(currentDetail: Get.find<MeController>().userDetailResult!)),
            title: I18n.meProfileSettingsPageTitle.tr,
          ),
          buildItem(
            onTap: () => Get.to(() => MeWorkspaceSettingsPage(workspace: Get.find<MeController>().userDetailResult!.workspace)),
            title: I18n.meWorkspaceSettingsPageTitle.tr,
          ),
          buildItem(
            onTap: () => Get.to(() => MeWebSettingsPage(currentDetail: Get.find<MeController>().userDetailResult!)),
            title: I18n.meWebSettingsPageTitle.tr,
          ),
        ],
      ),
    );
  }
}
