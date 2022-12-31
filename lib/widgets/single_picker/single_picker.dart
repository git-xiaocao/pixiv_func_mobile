import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class SinglePicker<V> extends StatelessWidget {
  final String title;
  final Map<String, V> items;
  final V initialValue;
  final ValueChanged<V> onChanged;

  const SinglePicker({
    Key? key,
    required this.title,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    V currentValue = items.values.toList().firstWhereOrNull((item) => item == initialValue) ?? items.values.first;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  TextWidget(title, fontSize: 18, isBold: true),
                ],
              ),
            ),
            NoScrollBehaviorWidget(
              child: SizedBox(
                height: Get.height * 0.35,
                child: CupertinoPicker(
                  itemExtent: 35,
                  useMagnifier: true,
                  magnification: 1.05,
                  onSelectedItemChanged: (index) {
                    currentValue = items.values.toList()[index];
                  },
                  scrollController: FixedExtentScrollController(initialItem: items.values.toList().indexOf(initialValue)),
                  children: [
                    for (final item in items.entries)
                      TextWidget(
                        item.key,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      color: const Color(0xFFE9E9EA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide.none,
                      ),
                      minWidth: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: TextWidget('取消', fontSize: 18, color: Theme.of(context).colorScheme.onBackground, isBold: true),
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      minWidth: double.infinity,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: TextWidget('确认', fontSize: 18, color: Colors.white, isBold: true),
                      ),
                      onPressed: () {
                        if (currentValue != initialValue) {
                          onChanged(currentValue);
                        }
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
