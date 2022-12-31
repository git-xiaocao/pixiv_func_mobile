import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class ScaffoldWidget extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool centerTitle;

  final bool emptyAppBar;
  final bool? resizeToAvoidBottomInset;
  final bool automaticallyImplyLeading;
  final Widget? child;
  final Widget? floatingActionButton;
  final VoidCallback? onBackPressed;

  const ScaffoldWidget({
    Key? key,
    this.title,
    this.titleWidget,
    this.actions,
    this.centerTitle = true,
    this.emptyAppBar = false,
    this.resizeToAvoidBottomInset,
    this.automaticallyImplyLeading = true,
    this.child,
    this.floatingActionButton,
    this.onBackPressed,
  }) : super(key: key);

  Widget _backButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onBackPressed ?? () => Get.back(),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Icon(Icons.arrow_back_ios_new),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppBar? appBar;
    if (emptyAppBar) {
      appBar = AppBar(
        elevation: 0,
        toolbarHeight: 0,
        // leading: automaticallyImplyLeading && (ModalRoute.of(context)?.canPop ?? false) ? _backButton() : null,
        automaticallyImplyLeading: false,
      );
    } else if (null != titleWidget) {
      appBar = AppBar(
        elevation: 0,
        title: titleWidget,
        centerTitle: centerTitle,
        leading: automaticallyImplyLeading && (ModalRoute.of(context)?.canPop ?? false) ? _backButton() : null,
        actions: actions,
        automaticallyImplyLeading: false,
      );
    } else if (null != title) {
      appBar = AppBar(
        elevation: 0,
        title: TextWidget(title!),
        centerTitle: centerTitle,
        leading: automaticallyImplyLeading && (ModalRoute.of(context)?.canPop ?? false) ? _backButton() : null,
        actions: actions,
        automaticallyImplyLeading: false,
      );
    } else {
      appBar = AppBar(
        elevation: 0,
        leading: automaticallyImplyLeading && (ModalRoute.of(context)?.canPop ?? false) ? _backButton() : null,
        actions: actions,
        automaticallyImplyLeading: false,
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      body: Padding(
        padding: Platform.isIOS ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom) : EdgeInsets.zero,
        child: child,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButton != null
          ? _CustomFloatingActionButtonLocation(
              location: FloatingActionButtonLocation.endDocked,
              offsetX: 0,
              offsetY: -Get.height * 0.1,
            )
          : null,
    );
  }
}

class _CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;
  double offsetY;

  _CustomFloatingActionButtonLocation({
    required this.location,
    required this.offsetX,
    required this.offsetY,
  });

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
