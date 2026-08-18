import 'package:flutter/material.dart';
import '../theme/app_scaling.dart';
import 'app_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppScaling.space16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: MediaQuery.sizeOf(context).width / 2,
              color: colorScheme.error,
            ),

            Text(
              message ?? 'Something went wrong',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppScaling.space24),
            if (onRetry != null)
              AppButton(
                text: 'Retry',
                onPressed: onRetry,
                size: ButtonSize.medium,
                isFullWidth: false,
                needElevation: true,
              ),
          ],
        ),
      ),
    );
  }
}
