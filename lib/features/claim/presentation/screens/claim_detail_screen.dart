import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_mod_b/core/utils/app_decoration.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/storage/preference_service.dart';
import '../../../../core/storage/receipt_storage.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_scaling.dart';
import '../../../../core/utils/date_extension.dart';
import '../../../../core/utils/extension.dart';
import '../../../../core/widgets/app_empty_widget.dart';
import '../../../employee/data/employee_repo.dart';
import '../../../employee/data/models/employee_model.dart';
import '../../data/claim_repo.dart';
import '../../data/models/claim_model.dart';
import '../../domain/enums/claim_status_enum.dart';
import '../bloc/claim_bloc.dart';
import '../bloc/claim_event.dart';
import '../bloc/claim_state.dart';
import '../widgets/claim_review_sheet.dart';
import '../widgets/claim_status_ui.dart';

class ClaimDetailScreen extends StatelessWidget {
  const ClaimDetailScreen({super.key, required this.claimId});

  final String claimId;

  @override
  Widget build(BuildContext context) {
    final employee = EmployeeRepository.getEmployeeByEmpId(
      PreferenceService.employeeId ?? "",
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Claim Details'),
        actions: [
          BlocBuilder<ClaimBloc, ClaimState>(
            builder: (context, state) {
              final claim = ClaimRepository.getClaimById(claimId);
              if (claim == null || !ClaimRepository.canEdit(claim)) {
                return const SizedBox.shrink();
              }

              return IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ClaimBloc, ClaimState>(
        listenWhen: (previous, current) =>
            previous.message != current.message && current.message != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message!)));
        },
        builder: (context, state) {
          final claim = ClaimRepository.getClaimById(claimId);

          if (claim == null) {
            return const AppEmptyWidget(
              message: 'This claim is no longer available.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppScaling.space16),
            children: [
              _buildHeaderCard(context, claim),
              const SizedBox(height: AppScaling.space16),
              _buildDetailsCard(context, claim, employee),
              const SizedBox(height: AppScaling.space16),
              _buildReceiptCard(context, claim),
              const SizedBox(height: AppScaling.space24),
              _buildActions(context, claim),
              const SizedBox(height: AppScaling.space24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, ClaimModel claim) {
    final theme = Theme.of(context);
    final status = claim.status;

    return Container(
      padding: EdgeInsets.all(AppScaling.space16),
      decoration: AppDecoration.cardOutlined(theme.colorScheme),
      child: Column(
        children: [
          StatusChip(status: status ?? ClaimStatus.pending),
          SizedBox(height: AppScaling.space8),
          Text(
            claim.amount?.formatAmount() ?? '—',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bloc = context.read<ClaimBloc>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this claim?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    bloc.add(ClaimDeleted(claimId));

    context.pop();
  }

  Widget _buildDetailsCard(
    BuildContext context,
    ClaimModel claim,
    EmployeeModel? employee,
  ) {
    final isRejected = claim.status?.isRejected ?? false;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const Divider(height: 1),
          _buildDetailRow(
            context,
            icon: Icons.person,
            label: 'Reporting Manager',
            value: employee?.reportingManager ?? '—',
          ),
          const Divider(height: 1),
          _buildDetailRow(
            context,
            icon: Icons.category_outlined,
            label: 'Category',
            value: claim.category?.label ?? '—',
          ),
          if ((claim.description ?? "").isNotEmpty) ...[
            const Divider(height: 1),
            _buildDetailRow(
              context,
              icon: Icons.description_outlined,
              label: 'Description',
              value: claim.description ?? '—',
            ),
          ],
          const Divider(height: 1),
          _buildDetailRow(
            context,
            icon: Icons.calendar_today_outlined,
            label: 'Expense date',
            value: claim.date?.toShortDate ?? '—',
          ),
          const Divider(height: 1),
          _buildDetailRow(
            context,
            icon: Icons.upload_file_outlined,
            label: 'Submitted',
            value: claim.createdAt?.toShortDate ?? '—',
          ),
          if (claim.reviewDate != null) ...[
            const Divider(height: 1),
            _buildDetailRow(
              context,
              icon: claim.status?.icon ?? Icons.info_outline,
              label: '${claim.status?.label ?? ''} on',
              value: claim.reviewDate!.toShortDate,
            ),
          ],
          // Only a rejection carries a reason the employee needs to act on.
          if (isRejected && claim.reviewComments != null) ...[
            const Divider(height: 1),
            _buildDetailRow(
              context,
              icon: Icons.error_outline,
              label: 'Rejection reason',
              value: claim.reviewComments!,
              isError: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isError = false,
  }) {
    final theme = Theme.of(context);
    final accent = isError
        ? theme.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;

    return Container(
      color: isError
          ? theme.colorScheme.errorContainer.withValues(alpha: 0.25)
          : null,
      padding: const EdgeInsets.all(AppScaling.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isError
                  ? theme.colorScheme.errorContainer
                  : theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: accent),
          ),
          const SizedBox(width: AppScaling.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: accent,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: AppScaling.space4),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard(BuildContext context, ClaimModel claim) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppScaling.space12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppScaling.space4,
                bottom: AppScaling.space8,
              ),
              child: Text('Receipt', style: theme.textTheme.titleMedium),
            ),
            FutureBuilder<String?>(
              future: ReceiptStorage.resolve(claim.receiptFileName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 190,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final path = snapshot.data;
                if (path == null) {
                  return AppEmptyWidget(message: "No receipt attached");
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.radius12),
                  child: Image.file(
                    File(path),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, ClaimModel claim) {
    final theme = Theme.of(context);
    final canEdit = ClaimRepository.canEdit(claim);

    return Column(
      children: [
        Text(
          'MANAGER ACTIONS',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppScaling.space12),
        Row(
          children: [
            if (canEdit) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.pushNamed(
                    RouteNames.editClaim,
                    pathParameters: {'id': claim.id ?? ''},
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: AppScaling.space12),
            ],
            Expanded(
              child: FilledButton.icon(
                onPressed: () =>
                    showReviewSheet(context: context, claim: claim),
                icon: const Icon(Icons.rule),
                label: const Text('Change status'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
