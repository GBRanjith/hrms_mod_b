import 'package:flutter/material.dart';
import 'package:hrms_mod_b/core/widgets/app_button.dart';
import '../theme/app_scaling.dart';

class AppEmptyWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRefresh;
  const AppEmptyWidget({super.key, required this.message, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppScaling.space16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: AppScaling.space24 * 2,
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: AppScaling.space12),

            Text(
              message,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              SizedBox(height: AppScaling.space16),
              AppButton(
                text: 'Refresh',
                onPressed: onRefresh,
                size: ButtonSize.medium,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
