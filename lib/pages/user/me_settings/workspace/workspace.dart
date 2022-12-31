import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/user/me_settings/workspace/controller.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class MeWorkspaceSettingsPage extends StatelessWidget {
  final UserWorkspace workspace;

  const MeWorkspaceSettingsPage({Key? key, required this.workspace}) : super(key: key);

  Widget buildItem({required String name, required TextEditingController controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075, vertical: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          label: TextWidget(name),
          constraints: const BoxConstraints(maxHeight: 40),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MeWorkspaceSettingsController(workspace));
    return GetBuilder<MeWorkspaceSettingsController>(
      builder: (controller) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: ScaffoldWidget(
          title: I18n.meWorkspaceSettingsPageTitle.tr,
          child: Column(
            children: [
              Flexible(
                child: ListView(
                  children: [
                    buildItem(name: I18n.workspacePc.tr, controller: controller.pcInput),
                    buildItem(name: I18n.workspaceMonitor.tr, controller: controller.monitorInput),
                    buildItem(name: I18n.workspaceTool.tr, controller: controller.toolInput),
                    buildItem(name: I18n.workspaceScanner.tr, controller: controller.scannerInput),
                    buildItem(name: I18n.workspaceTablet.tr, controller: controller.tabletInput),
                    buildItem(name: I18n.workspaceMouse.tr, controller: controller.mouseInput),
                    buildItem(name: I18n.workspacePrinter.tr, controller: controller.printerInput),
                    buildItem(name: I18n.workspaceDesktop.tr, controller: controller.desktopInput),
                    buildItem(name: I18n.workspaceMusic.tr, controller: controller.musicInput),
                    buildItem(name: I18n.workspaceDesk.tr, controller: controller.deskInput),
                    buildItem(name: I18n.workspaceChair.tr, controller: controller.chairInput),
                    buildItem(name: I18n.workspaceOther.tr, controller: controller.commentInput),
                  ],
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
                    child: TextWidget(I18n.workspaceUpdate.tr, fontSize: 18, color: Colors.white, isBold: true),
                  ),
                  onPressed: () => controller.updateWorkspace(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
