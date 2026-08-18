import 'package:flutter/material.dart';

import '../theme/app_scaling.dart';

enum ButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final bool needElevation;
  final bool enabled;
  final String? tooltip;
  final EdgeInsets? customPadding;
  final bool isOutlined;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.needElevation = false,
    this.enabled = true,
    this.tooltip,
    this.customPadding,
    this.isOutlined = false,
  });

  bool get _isEnabled => enabled && onPressed != null && !isLoading;

  EdgeInsets _resolvePadding() {
    if (customPadding != null) return customPadding!;
    return switch (size) {
      ButtonSize.small => EdgeInsets.symmetric(
        horizontal: AppScaling.space8,
        vertical: AppScaling.space4,
      ),
      ButtonSize.medium => EdgeInsets.symmetric(
        horizontal: AppScaling.space12,
        vertical: AppScaling.space8,
      ),
      ButtonSize.large => EdgeInsets.symmetric(
        horizontal: AppScaling.space16,
        vertical: AppScaling.space12,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = switch (size) {
      ButtonSize.small => textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      ButtonSize.medium => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      ButtonSize.large => textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    };
    final style = ButtonStyle(
      padding: WidgetStateProperty.all(_resolvePadding()),
      textStyle: WidgetStateProperty.all(textStyle),
    );

    Widget btn;
    if (isOutlined) {
      btn = OutlinedButton(
        onPressed: _isEnabled ? onPressed : null,
        style: style,
        child: _content(context),
      );
    } else if (needElevation) {
      btn = ElevatedButton(
        onPressed: _isEnabled ? onPressed : null,
        style: style,
        child: _content(context),
      );
    } else {
      btn = FilledButton(
        onPressed: _isEnabled ? onPressed : null,
        style: style,
        child: _content(context),
      );
    }

    if (isFullWidth) {
      btn = SizedBox(width: double.infinity, child: btn);
    }
    if (tooltip != null && tooltip!.isNotEmpty) {
      btn = Tooltip(message: tooltip!, child: btn);
    }
    return btn;
  }

  Widget _content(BuildContext context) {
    if (isLoading) {
      return SizedBox.square(
        dimension: AppScaling.space24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
          ),
        ),
      );
    }
    if (icon == null) {
      return Text(text, overflow: TextOverflow.ellipsis, maxLines: 1);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon!,
        SizedBox(width: AppScaling.space8),
        Flexible(
          child: Text(text, overflow: TextOverflow.ellipsis, maxLines: 1),
        ),
      ],
    );
  }
}
