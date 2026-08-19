  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms_mod_b/features/claim/presentation/widgets/claim_status_ui.dart';
import '../../../../core/theme/app_scaling.dart';
import '../../data/models/claim_model.dart';
import '../../domine/enums/claim_status_enum.dart';
import '../bloc/claim_bloc.dart';
import '../bloc/claim_event.dart';

Future<void> showReviewSheet({required BuildContext context, required ClaimModel claim}) async {
    final bloc = context.read<ClaimBloc>();
    final chosen = await showModalBottomSheet<ClaimStatus>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppScaling.space16,
                0,
                AppScaling.space16,
                AppScaling.space8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Simulate manager review',
                    style: Theme.of(sheetContext).textTheme.titleMedium,
                  ),
                  Text(
                    'Demo shortcut — this module has no manager login.',
                    style: Theme.of(sheetContext).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            ...ClaimStatus.values.map(
              (status) => ListTile(
                leading: Icon(status.icon, color: status.color(sheetContext)),
                title: Text(status.label),
                subtitle: status == claim.status
                    ? const Text('Current status')
                    : null,
                enabled: status != claim.status,
                onTap: () => Navigator.of(sheetContext).pop(status),
              ),
            ),
          ],
        ),
      ),
    );

    if (chosen == null) return;
    bloc.add(ClaimReviewed(id: claim.id ?? '', status: chosen));
  }