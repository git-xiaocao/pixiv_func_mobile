import 'package:flutter/cupertino.dart';

class SlidingSegmentedControl<T extends Object> extends StatelessWidget {
  final Map<T, Widget> children;
  final ValueChanged<T?> onValueChanged;
  final T? groupValue;
  final bool splitEqually;

  const SlidingSegmentedControl({
    Key? key,
    required this.children,
    required this.groupValue,
    required this.onValueChanged,
    this.splitEqually = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (splitEqually) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: CupertinoSlidingSegmentedControl(
              children: children.map(
                (key, value) => MapEntry(
                  key,
                  Container(
                    alignment: Alignment.center,
                    width: constraints.maxWidth / children.length,
                    child: value,
                  ),
                ),
              ),
              groupValue: groupValue,
              onValueChanged: onValueChanged,
            ),
          );
        },
      );
    } else {
      return CupertinoSlidingSegmentedControl(
        children: children,
        groupValue: groupValue,
        onValueChanged: onValueChanged,
      );
    }
  }
}
