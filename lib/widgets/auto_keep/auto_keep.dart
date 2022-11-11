import 'package:flutter/material.dart';

class AutoKeepWidget extends StatefulWidget {
  final Widget child;

  const AutoKeepWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<AutoKeepWidget> createState() => _AutoKeepWidgetState();
}

class _AutoKeepWidgetState extends State<AutoKeepWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
