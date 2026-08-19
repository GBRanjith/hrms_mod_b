import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_filter_chips.dart';
import '../../domine/bloc/expense_claim_bloc.dart';
import '../../domine/bloc/expense_claim_event.dart';
import '../../domine/bloc/expense_claim_state.dart';
import '../../domine/enums/claim_status_enum.dart';

class ClaimStatusFilter extends StatelessWidget {
  const ClaimStatusFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseClaimBloc, ExpenseClaimState>(
      buildWhen: (previous, current) =>
          previous.claimStatus != current.claimStatus,
      builder: (context, state) {
        return AppFilterChips<ClaimStatus>(
          items: ClaimStatus.values,
          selected: state.claimStatus,
          labelOf: (item) => item.label,
          onSelected: (status) {
            context.read<ExpenseClaimBloc>().add(
              ExpenseClaimStatusSelected(status),
            );
          },
        );
      },
    );
  }
}
