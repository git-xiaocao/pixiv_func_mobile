import 'package:flutter/material.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class SelectGroup<T> extends StatelessWidget {
  final Map<String, T> items;
  final T value;
  final ValueChanged<T> onChanged;

  const SelectGroup({Key? key, required this.items, required this.value, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (final item in items.entries)
          if (value == item.value)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(17),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextWidget(item.key, fontSize: 16, color: Colors.white, isBold: true),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(item.value),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextWidget(item.key, fontSize: 16, isBold: true),
                ),
              ),
            )
      ],
    );
  }
}
