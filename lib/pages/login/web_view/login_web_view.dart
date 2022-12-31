import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/webview/platform_webview.dart';
import 'package:pixiv_func_mobile/app/theme.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class LoginWebViewPage extends StatelessWidget {
  final bool useLocalReverseProxy;
  final bool create;

  const LoginWebViewPage({Key? key, required this.useLocalReverseProxy, required this.create}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginWebViewController(create));
    return GetBuilder<LoginWebViewController>(
      builder: (controller) => ScaffoldWidget(
        onBackPressed: () async => await controller.webViewController.canGoBack() ? controller.webViewController.goBack() : Get.back(),
        actions: [
          if (controller.isLoginPage)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.getLoginDataFromWebView();
                Get.bottomSheet(
                  Container(
                    color: Colors.white,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: Get.height * 0.35, minHeight: Get.height * 0.35),
                      child: Column(
                        children: [
                          const Spacer(flex: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                TextWidget(I18n.clipboard.tr, fontSize: 18, color: lightTheme.colorScheme.onSurface, isBold: true),
                              ],
                            ),
                          ),
                          const Spacer(flex: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                TextWidget(I18n.account.tr, fontSize: 16, color: lightTheme.colorScheme.onSurface, isBold: true),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: controller.accountInputController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      constraints: const BoxConstraints(maxHeight: 40),
                                      hintText: I18n.pixivAccountHint.tr,
                                      hintStyle: const TextStyle(color: Color(0xFFBCBCBD)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFE9E9EA),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Spacer(flex: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                TextWidget(I18n.password.tr, fontSize: 16, color: lightTheme.colorScheme.onSurface, isBold: true),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: controller.passwordInputController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      constraints: const BoxConstraints(maxHeight: 40),
                                      hintText: I18n.password.tr,
                                      hintStyle: const TextStyle(color: Color(0xFFBCBCBD)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFE9E9EA),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    ),
                                  ),
                                )
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
                                    color: const Color(0xFFE9E9EA),
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
                                    color: Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    minWidth: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: TextWidget(I18n.pasteIn.tr, fontSize: 18, color: Colors.white, isBold: true),
                                    ),
                                    onPressed: () {
                                      controller.copyLoginDataToWebView();
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
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextWidget(I18n.noEntry.tr, color: Theme.of(context).colorScheme.primary, fontSize: 14),
                ),
              ),
            ),
          IconButton(onPressed: () => controller.webViewController.reload(), icon: const Icon(Icons.refresh)),
        ],
        title: controller.title,
        child: PlatformWebView(
          tag: 'PlatformWebView:LoginWebViewPage',
          onMessageHandler: controller.onMessageHandler,
          useLocalReverseProxy: useLocalReverseProxy,
          onCreated: controller.onWebViewCreated,
        ),
      ),
    );
  }
}
