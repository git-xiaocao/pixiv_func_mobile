import 'package:flutter/material.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/dropdown/dropdown.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class SelectButtonWidget<V> extends StatelessWidget {
  final Map<String, V> items;
  final V value;
  final ValueChanged<V?> onChanged;

  const SelectButtonWidget({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final textSizes = items.keys.map((key) => Utils.getTextSize(text: key)).toList()..sort((a, b) => a.width > b.width ? -1 : 1);
    final maxWidth = 8 + 4 + 10 + 12 + 14 / 2 + textSizes.first.width;
    return Container(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 35,
        width: maxWidth,
        child: DropdownButtonWidgetHideUnderline(
          child: DropdownButtonWidget<V>(
            isDense: true,
            elevation: 0,
            isExpanded: true,
            borderRadius: BorderRadius.circular(12),
            items: [
              for (final item in items.entries)
                DropdownMenuItemWidget<V>(
                  value: item.value,
                  child: Container(
                    height: 35,
                    width: maxWidth,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      border: value == item.value ? Border.all(color: Theme.of(context).colorScheme.primary) : null,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        const Icon(AppIcons.toggle, size: 12),
                        const SizedBox(width: 10),
                        TextWidget(
                          item.key,
                          fontSize: 14,
                          forceStrutHeight: true,
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
            ],
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
