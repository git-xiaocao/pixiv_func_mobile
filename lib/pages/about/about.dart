import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/global_controllers/about_controller.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  Widget buildItem({required VoidCallback onTap, required String title}) {
    return ListTile(
      onTap: onTap,
      title: TextWidget(title, fontSize: 16, isBold: true),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  Widget buildButton() {
    final controller = Get.find<AboutController>();
    final String text;
    final Color? color;
    final Color? textColor;
    final BorderSide borderSide;
    final VoidCallback? onPressed;
    if (PageState.none == controller.state) {
      if (null == controller.hasNewVersion) {
        text = I18n.checkVersionHint.tr;
        color = null;
        textColor = Get.theme.colorScheme.primary;
        borderSide = BorderSide(color: Get.theme.colorScheme.primary);
        onPressed = controller.loadData;
      } else if (controller.hasNewVersion!) {
        text = I18n.hasNewVersionHint.tr;
        color = Get.theme.colorScheme.primary;
        textColor = Colors.white;
        borderSide = BorderSide.none;
        onPressed = controller.updateApp;
      } else {
        text = I18n.noNewVersionHint.tr;
        color = Get.theme.colorScheme.surface;
        textColor = Colors.white;
        borderSide = BorderSide.none;
        onPressed = controller.loadData;
      }
    } else if (PageState.loading == controller.state) {
      text = I18n.checkingVersionHint.tr;
      color = Get.theme.colorScheme.surface;
      textColor = Get.theme.colorScheme.primary;
      borderSide = BorderSide(color: Get.theme.colorScheme.primary);
      onPressed = null;
    } else if (PageState.error == controller.state) {
      text = I18n.checkVersionErrorHint.tr;
      color = Get.theme.colorScheme.surface;
      textColor = Get.theme.colorScheme.primary;
      borderSide = BorderSide(color: Get.theme.colorScheme.primary);
      onPressed = controller.loadData;
    } else {
      text = '';
      color = null;
      textColor = null;
      borderSide = BorderSide.none;
      onPressed = null;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
      child: MaterialButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: borderSide,
        ),
        color: color,
        minWidth: double.infinity,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: TextWidget(text, fontSize: 18, color: textColor, isBold: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutController>(
      builder: (controller) => ScaffoldWidget(
        title: I18n.aboutPageTitle.tr,
        child: Column(
          children: [
            const Divider(),
            buildItem(onTap: () => controller.action(0), title: I18n.contactAuthor.tr),
            const Divider(),
            buildItem(onTap: () => controller.action(1), title: I18n.getHelp.tr),
            const Divider(),
            buildItem(onTap: () => controller.action(2), title: I18n.currentVersion.trArgs([controller.appVersion ?? '...'])),
            const Divider(),
            buildItem(onTap: () => controller.action(3), title: I18n.openTagPage.tr),
            const Divider(),
            const Spacer(),
            buildButton(),
            SizedBox(height: Get.height * 0.05),
          ],
        ),
      ),
    );
  }
}
