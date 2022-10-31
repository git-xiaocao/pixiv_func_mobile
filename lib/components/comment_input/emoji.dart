import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_mobile/app/asset_manifest/asset_manifest.dart';

class EmojiText extends SpecialText {
  static const String flag = '(';
  final int start;
  final double? multiple;

  EmojiText(TextStyle? textStyle, {required this.start, this.multiple}) : super(EmojiText.flag, ')', textStyle);

  @override
  InlineSpan finishText() {
    final String key = toString();
    final String name = key.substring(1, key.length - 1);
    if (key.isNotEmpty && assetManifest.emojis.any((item) => name == item.name)) {
      return ImageSpan(
        AssetImage(assetManifest.emojis.singleWhere((item) => name == item.name).fullPath),
        actualText: key,
        imageWidth: (textStyle?.fontSize ?? 16) * (multiple ?? 1),
        imageHeight: (textStyle?.fontSize ?? 16) * (multiple ?? 1),
        start: start,
        margin: const EdgeInsets.all(2),
      );
    } else {
      return TextSpan(
        text: key,
      );
    }
  }
}

class EmojisSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  final double? multiple;

  EmojisSpecialTextSpanBuilder({this.multiple});

  @override
  SpecialText? createSpecialText(String flag, {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, required int index}) {
    if (flag == '') {
      return null;
    }
    if (isStart(flag, "(")) {
      return EmojiText(textStyle, start: index - (EmojiText.flag.length - 1), multiple: multiple);
    }
    return null;
  }
}
