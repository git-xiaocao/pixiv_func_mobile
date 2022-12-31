import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/login/controller.dart';
import 'package:pixiv_func_mobile/pages/login/web_view/login_web_view.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class LoginPage extends StatelessWidget {
  final bool isFirst;

  const LoginPage({Key? key, this.isFirst = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return GetBuilder<LoginController>(
      builder: (controller) => ScaffoldWidget(
        titleWidget: isFirst ? null : TextWidget(I18n.loginPageTitle.tr, fontSize: 24, isBold: true),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
          child: Column(
            children: [
              const Spacer(flex: 1),
              if (isFirst) TextWidget(I18n.loginPageTitle.tr, fontSize: 24, isBold: true),
              const Spacer(flex: 2),
              SizedBox(
                height: Get.height * 0.4,
                child: Column(
                  children: [
                    CupertinoSwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 6),
                      onTap: () => controller.useLocalReverseProxy = !controller.useLocalReverseProxy,
                      value: controller.useLocalReverseProxy,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(I18n.localReverseProxy.tr, fontSize: 18, isBold: true),
                          const SizedBox(width: 8),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              controller.help = !controller.help;
                            },
                            child: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    if (controller.help)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: I18n.reverseProxyHint.tr,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            TextSpan(
                              text: I18n.getMoreHelp.tr,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    if (controller.help)
                      Column(
                        children: [
                          TextWidget(I18n.useLoginWithClipboardHint.tr, fontSize: 18, isBold: true),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (controller.help)
                      MaterialButton(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        minWidth: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TextWidget(I18n.useLoginWithClipboard.tr, fontSize: 18, color: Colors.white, isBold: true),
                        ),
                        onPressed: () => controller.loginWithClipboard(),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                              ),
                              minWidth: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child:
                                    TextWidget(I18n.register.tr, fontSize: 18, color: Theme.of(context).colorScheme.primary, isBold: true),
                              ),
                              onPressed: () =>
                                  Get.to(() => LoginWebViewPage(useLocalReverseProxy: controller.useLocalReverseProxy, create: true)),
                            ),
                          ),
                          const SizedBox(width: 20),
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
                                child: TextWidget(I18n.login.tr, fontSize: 18, color: Colors.white, isBold: true),
                              ),
                              onPressed: () =>
                                  Get.to(() => LoginWebViewPage(useLocalReverseProxy: controller.useLocalReverseProxy, create: false)),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              TextWidget(I18n.loginAgree.tr, fontSize: 14),
              TextWidget(I18n.userAgreement.tr, fontSize: 14, color: Theme.of(context).colorScheme.primary),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
