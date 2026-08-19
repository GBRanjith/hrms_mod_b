import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_scaling.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state.status.isSuccess && state.nextRoute != null) {
          context.goNamed(state.nextRoute!);
        }
      },
      builder: (context, state) {
        if (state.status.isFailure) {
          return Scaffold(
            body: AppErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<SplashBloc>().add(SplashStarted());
              },
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              tween: Tween(begin: 0.7, end: 1),
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.badge_rounded,
                    size: MediaQuery.sizeOf(context).width / 2,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: AppScaling.space16),
                  Text(AppConstants.appName, style: textTheme.headlineSmall),
                  const SizedBox(height: AppScaling.space4),
                  Text(
                    AppConstants.moduleName,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppScaling.space24),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
