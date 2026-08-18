import 'package:flutter/material.dart';
import '../theme/app_scaling.dart';

class AppFilterChips<T> extends StatelessWidget {
  const AppFilterChips({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<T> items;
  final T? selected;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppScaling.space16),
        children: [
          _chip('All', null),
          ...items.map((item) => _chip(item.toString(), item)),
        ],
      ),
    );
  }

  Widget _chip(String label, T? value) {
    return Padding(
      padding: const EdgeInsets.only(right: AppScaling.space4),
      child: FilterChip(
        padding: const EdgeInsets.all(0),
        visualDensity: VisualDensity.compact,
        label: Text(label),
        selected: selected == value,
        showCheckmark: false,
        onSelected: (_) => onSelected(value),
      ),
    );
  }
}
