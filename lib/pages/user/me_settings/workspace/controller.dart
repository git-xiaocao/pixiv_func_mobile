import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/pages/user/controller.dart';

class MeWorkspaceSettingsController extends GetxController {
  MeWorkspaceSettingsController(UserWorkspace workspace)
      : pcInput = TextEditingController(text: workspace.pc),
        monitorInput = TextEditingController(text: workspace.monitor),
        tabletInput = TextEditingController(text: workspace.tablet),
        toolInput = TextEditingController(text: workspace.tool),
        scannerInput = TextEditingController(text: workspace.scanner),
        mouseInput = TextEditingController(text: workspace.mouse),
        printerInput = TextEditingController(text: workspace.printer),
        desktopInput = TextEditingController(text: workspace.desktop),
        musicInput = TextEditingController(text: workspace.music),
        deskInput = TextEditingController(text: workspace.desk),
        chairInput = TextEditingController(text: workspace.chair),
        commentInput = TextEditingController(text: workspace.comment);

  final TextEditingController pcInput;

  final TextEditingController monitorInput;
  final TextEditingController toolInput;
  final TextEditingController scannerInput;
  final TextEditingController tabletInput;
  final TextEditingController mouseInput;
  final TextEditingController printerInput;
  final TextEditingController desktopInput;
  final TextEditingController musicInput;
  final TextEditingController deskInput;
  final TextEditingController chairInput;
  final TextEditingController commentInput;

  void updateWorkspace() {
    final workspace = UserWorkspace(
      pcInput.text,
      monitorInput.text,
      toolInput.text,
      scannerInput.text,
      tabletInput.text,
      mouseInput.text,
      printerInput.text,
      desktopInput.text,
      musicInput.text,
      deskInput.text,
      chairInput.text,
      commentInput.text,
      null,
    );
    Get.find<ApiClient>()
        .postWorkspaceEdit(
      workspace: workspace,
    )
        .then((_) {
      PlatformApi.toast(I18n.updateWorkspaceSuccess.tr);
      Get.find<MeController>().userDetailResult!.workspace = workspace;
      Get.find<MeController>().update();
    }).catchError((e) {
      PlatformApi.toast(I18n.updateWorkspaceFailed.tr);
    });
  }
}
