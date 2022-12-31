import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final TextOverflow? overflow;
  final bool isBold;
  final bool forceStrutHeight;
  final int? maxLines;
  final Locale? locale;
  const TextWidget(
    this.text, {
    Key? key,
    this.fontSize,
    this.color,
    this.overflow,
    this.isBold = false,
    this.forceStrutHeight = false,
    this.maxLines,
    this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      strutStyle: forceStrutHeight
          ? const StrutStyle(
              forceStrutHeight: true,
            )
          : null,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        overflow: overflow,
        decoration: TextDecoration.none,
      ),
      locale: locale,
    );
  }
}
