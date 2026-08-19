import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_scaling.dart';
import '../../../../core/utils/app_decoratoin.dart';
import '../../../../core/utils/extension.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/logout_button.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc()..add(DashboardStarted()),
      child: _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arche HRMS'),
        actions: [LogoutButton()],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status.isInitial || state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status.isFailure) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<DashboardBloc>().add(DashboardStarted()),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppScaling.space16),
            children: [
              Text(
                'Hello, ${state.employeeName}',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppScaling.space4),
              Text(
                "Here is what's happening today.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppScaling.space24),
              Container(
                decoration: AppDecoration.card(theme.colorScheme),
                child: ListTile(
                  leading: _iconBubble(
                    context,
                    Icons.groups,
                    theme.colorScheme.primary,
                  ),
                  title: Text(
                    'Total Employees',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  subtitle: Text(
                    '${state.totalEmployees}',
                    style: theme.textTheme.headlineSmall,
                  ),
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ),
              ),
              const SizedBox(height: AppScaling.space12),
              Row(
                children: [
                  Expanded(
                    child: _statTile(
                      context,
                      icon: Icons.pending_actions,
                      accent: Theme.of(context).colorScheme.error,
                      value: '${state.pendingClaims}',
                      label: 'Pending Claims',
                    ),
                  ),
                  const SizedBox(width: AppScaling.space12),
                  Expanded(
                    child: _statTile(
                      context,
                      icon: Icons.check_circle,
                      accent: Theme.of(context).colorScheme.primary,
                      value: state.approvedThisMonth.formatAmount(),
                      label: 'Approved this month',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppScaling.space24),
              Text('Quick Actions', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppScaling.space12),
              Row(
                children: [
                  Expanded(
                    child: _actionTile(
                      context,
                      icon: Icons.search,
                      label: 'Directory',
                      onTap: () {
                        context.pushNamed(RouteNames.directory);
                      },
                    ),
                  ),
                  const SizedBox(width: AppScaling.space12),
                  Expanded(
                    child: _actionTile(
                      context,
                      icon: Icons.add_card,
                      label: 'New Claim',
                      onTap: () => context.pushNamed(RouteNames.createClaim),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statTile(
    BuildContext context, {
    required IconData icon,
    required Color accent,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: AppDecoration.card(theme.colorScheme),
      child: Padding(
        padding: const EdgeInsets.all(AppScaling.space12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: AppScaling.space24, color: accent),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      value,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppScaling.space8),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppScaling.space12),
          child: Row(
            children: [
              _iconBubble(context, icon, theme.colorScheme.primary),
              const SizedBox(width: AppScaling.space12),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBubble(BuildContext context, IconData icon, Color accent) {
    return Container(
      padding: EdgeInsets.all(AppScaling.space4),
      height: AppScaling.space40,
      width: AppScaling.space40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.radius12),
      ),
      child: Icon(icon, size: AppScaling.space24, color: accent),
    );
  }
}
