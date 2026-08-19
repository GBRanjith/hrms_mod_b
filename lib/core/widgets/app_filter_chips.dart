import 'package:flutter/material.dart';
import '../theme/app_scaling.dart';

class AppFilterChips<T> extends StatelessWidget {
  const AppFilterChips({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
    this.allLabel = 'All',
    this.removeAll = false,
    this.labelOf,
  });

  final List<T> items;
  final T? selected;
  final String allLabel;
  final bool removeAll;
  final String Function(T item)? labelOf;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppScaling.space16),
        children: [
          if (removeAll) _chip(allLabel, null),
          ...items.map(
            (item) => _chip(labelOf?.call(item) ?? item.toString(), item),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, T? value) {
    return Padding(
      padding: const EdgeInsets.only(right: AppScaling.space4),
      child: FilterChip(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        label: Text(label),
        selected: selected == value,
        showCheckmark: false,
        onSelected: (_) => onSelected(value),
      ),
    );
  }
}
