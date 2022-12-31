import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;

class Utils {
  Utils._();

  ///格式化时间
  static String dateFormat(DateTime dateTime) {
    return DateFormat('yyyy年MM月dd日 HH:mm:ss').format(dateTime.toLocal());
  }

  static Future<void> copyToClipboard(String data) async {
    await Clipboard.setData(ClipboardData(text: data));
  }

  ///字符串是否是 twitter/用户名
  static bool textIsTwitterUser(String text) {
    return RegExp(r'([Tt]witter/)(\w{1,15})\b').hasMatch(text);
  }

  ///查找文本里的推特用户名
  static String findTwitterUsernameByText(String url) {
    return RegExp(r'(?<=([Tt]witter/))(\w{1,15})\b$').stringMatch(url)!;
  }

  ///推特账号(https://twitter.com https://mobile.twitter.com)
  static bool urlIsTwitter(String url) {
    return RegExp(r'(https://).*(twitter.com/)(\w{1,15})\b$').hasMatch(url);
  }

  ///查找url里的推特用户名
  static String findTwitterUsernameByUrl(String url) {
    return RegExp(r'(?<=(https://).*(twitter.com/))(\w{1,15})\b$').stringMatch(url)!;
  }

  ///插画页面
  static bool urlIsIllust(String url) {
    return RegExp(r'pixiv://illusts/([1-9][0-9]*)\b').hasMatch(url);
  }

  ///查找url里的插画ID
  static int findIllustIdByUrl(String url) {
    return int.parse(RegExp(r'(?<=pixiv://illusts/)([1-9][0-9]*)\b').stringMatch(url)!);
  }

  ///用户页面
  static bool urlIsUser(String url) {
    return RegExp(r'pixiv://users/([1-9][0-9]*)\b').hasMatch(url);
  }

  ///查找url里的用户ID
  static int findUserIdByUrl(String url) {
    return int.parse(RegExp(r'(?<=pixiv://users/)([1-9][0-9]*)\b').stringMatch(url)!);
  }

  static Size getTextSize({required String text, double maxWidth = double.infinity, TextStyle? style}) {
    TextPainter painter = TextPainter(
      locale: WidgetsBinding.instance.window.locale,
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 2 ^ 31,
    )..layout(maxWidth: maxWidth);
    return painter.size;
  }
}
