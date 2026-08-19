import 'package:flutter/material.dart';
import 'package:hrms_mod_b/core/utils/date_extension.dart';
import 'package:hrms_mod_b/core/utils/extension.dart';
import 'package:hrms_mod_b/features/claim/domine/enums/expense_category_enum.dart';
import 'package:hrms_mod_b/features/claim/presentation/widgets/claim_status_ui.dart';
import '../../../../core/theme/app_scaling.dart';
import '../../data/models/claim_model.dart';
import '../../domine/enums/claim_status_enum.dart';

class ClaimItem extends StatelessWidget {
  const ClaimItem({
    super.key,
    required this.claim,
    required this.onTap,
    required this.onLongPress,
  });

  final ClaimModel claim;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        margin: const EdgeInsets.only(bottom: AppScaling.space8),
        child: Padding(
          padding: const EdgeInsets.all(AppScaling.space12),
          child: Column(
            children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),
                leading: CircleAvatar(
                  child: _buildAvatar(claim.category ?? ExpenseCategory.other),
                ),
                title: Text(
                  claim.category?.label ?? '-',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (claim.description?.isNotEmpty == true)
                      Text(
                        claim.description ?? '-',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    if (claim.reviewComments?.isNotEmpty == true)
                      Text(
                        "Reject Reason: ${claim.reviewComments ?? '-'}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
                trailing: Text(
                  claim.amount?.formatAmount() ?? "-",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                titleAlignment: ListTileTitleAlignment.top,
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    claim.date?.toShortDate ?? "-",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Spacer(),
                  StatusChip(status: claim.status ?? ClaimStatus.pending),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ExpenseCategory category) {
    final icon = switch (category) {
      ExpenseCategory.travel => Icons.flight,
      ExpenseCategory.food => Icons.restaurant,
      ExpenseCategory.accommodation => Icons.hotel,
      ExpenseCategory.clientVisit => Icons.business,
      ExpenseCategory.other => Icons.receipt_long,
    };

    return CircleAvatar(child: Icon(icon));
  }
}
