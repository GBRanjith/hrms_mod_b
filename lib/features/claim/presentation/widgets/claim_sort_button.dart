import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/sort_enum.dart';
import '../bloc/claim_bloc.dart';
import '../bloc/claim_event.dart';
import '../bloc/claim_state.dart';

class ClaimSortButton extends StatelessWidget {
  const ClaimSortButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClaimBloc, ClaimState>(
      buildWhen: (previous, current) => previous.sort != current.sort,
      builder: (context, state) {
        final isNewest = state.sort == Sort.newestFirst;

        return IconButton(
          tooltip: isNewest ? 'Newest first' : 'Oldest first',
          icon: Icon(isNewest ? Icons.arrow_downward : Icons.arrow_upward),
          onPressed: () => context.read<ClaimBloc>().add(
            ClaimSortChanged(isNewest ? Sort.oldestFirst : Sort.newestFirst),
          ),
        );
      },
    );
  }
}