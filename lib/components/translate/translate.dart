import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/services/settings_service.dart';
import 'package:pixiv_func_mobile/app/services/translate_service.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class TranslateWidget extends StatefulWidget {
  final int id;
  final String text;
  final Widget child;

  const TranslateWidget({
    Key? key,
    required this.id,
    required this.text,
    required this.child,
  }) : super(key: key);

  @override
  State<TranslateWidget> createState() => _TranslateWidgetState();
}

class _TranslateWidgetState extends State<TranslateWidget> {
  late final text = widget.text;
  bool loading = false;

  String? translateText;

  void onTranslation() {
    setState(() {
      loading = true;
    });
    Get.find<TranslateService>()
        .current
        .translationText(text: text, source: null, target: Get.find<SettingsService>().language)
        .then((result) {
      setState(() {
        translateText = result;
        loading = false;
      });
    }).catchError((e) {
      PlatformApi.toast('Translate failed');
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.child,
        if (translateText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.surface,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    Get.find<TranslateService>().current.name,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Divider(),
                  TextWidget(translateText!, fontSize: 16),
                ],
              ),
            ),
          )
        else if (loading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8).add(const EdgeInsets.only(bottom: 2)),
            child: const CupertinoActivityIndicator(),
          )
        else
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTranslation(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextWidget(
                '翻译此评论',
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
