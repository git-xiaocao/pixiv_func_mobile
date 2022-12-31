import 'package:flutter/material.dart';
import 'package:pixiv_func_mobile/components/pixiv_image/pixiv_image.dart';

class PixivAvatarWidget extends StatelessWidget {
  final String url;
  final double? radius;
  final Widget Function(Widget imageWidget)? imageBuilder;
  final String? host;

  const PixivAvatarWidget(
    this.url, {
    Key? key,
    this.radius,
    this.imageBuilder,
    this.host,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: PixivImageWidget(
        url,
        fit: BoxFit.cover,
        width: radius ?? 40,
        height: radius ?? 40,
        imageBuilder: imageBuilder,
        host: host,
      ),
    );
  }
}
