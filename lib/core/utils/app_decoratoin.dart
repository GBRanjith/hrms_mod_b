import 'package:flutter/material.dart';
import 'package:hrms_mod_b/core/theme/app_scaling.dart';

/// Reusable decorations for the app
class AppDecoration {
  AppDecoration._();

  static BoxDecoration card(ColorScheme colorScheme) => BoxDecoration(
    color: colorScheme.surfaceContainerLow,
    border: Border.all(color: colorScheme.outlineVariant),
    borderRadius: BorderRadius.circular(AppScaling.space12),
    boxShadow: [
      BoxShadow(
        color: colorScheme.shadow.withValues(alpha: 0.08),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration cardOutlined(ColorScheme colorScheme) => BoxDecoration(
    color: colorScheme.surface,
    borderRadius: BorderRadius.circular(AppScaling.space12),
    border: Border.all(color: colorScheme.outlineVariant),
  );

  static BoxDecoration container(ColorScheme colorScheme) => BoxDecoration(
    color: colorScheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(AppScaling.space12),
  );
}
