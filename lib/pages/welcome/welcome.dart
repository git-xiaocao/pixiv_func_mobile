import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/pages/guide/setup0/select_language.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      emptyAppBar: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            const TextWidget('感谢使用Pixiv Func', fontSize: 24, isBold: true),
            const TextWidget('下面将进行首次启动设置', fontSize: 24, isBold: true),
            const Spacer(flex: 2),
            MaterialButton(
              elevation: 0,
              color: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              minWidth: double.infinity,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: TextWidget('开始', fontSize: 18, color: Colors.white, isBold: true),
              ),
              onPressed: () => Get.to(() => const GuideSelectLanguagePage()),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
