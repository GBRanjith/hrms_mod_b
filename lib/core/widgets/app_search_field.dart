import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_radius.dart';

class AppSearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String?> onChanged;
  final Duration debounce;
  const AppSearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.debounce,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  final _controller = TextEditingController();
  Timer? _timer;

  void _onSearchChanged(String? value) {
    _timer?.cancel();
    _timer = Timer(widget.debounce, () {
      if (mounted) widget.onChanged(value?.isEmpty ?? true ? null : value);
    });
    setState(() {});
  }

  void _onClear() {
    _timer?.cancel();
    _controller.clear();
    widget.onChanged(null);
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onSearchChanged,
      textInputAction: TextInputAction.search,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.close), onPressed: _onClear)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radius12),
        ),
      ),
    );
  }
}
