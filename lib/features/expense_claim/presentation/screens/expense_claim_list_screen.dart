import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_scaling.dart';
import '../../../../core/widgets/app_empty_widget.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../domine/bloc/expense_claim_bloc.dart';
import '../../domine/bloc/expense_claim_event.dart';
import '../../domine/bloc/expense_claim_state.dart';
import '../widgets/claim_item.dart';
import '../widgets/claim_status_filter.dart';

class ExpenseClaimListScreen extends StatelessWidget {
  const ExpenseClaimListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseClaimBloc()..add(ExpenseClaimStarted()),
      child: const _ExpenseClaimListView(),
    );
  }
}

class _ExpenseClaimListView extends StatefulWidget {
  const _ExpenseClaimListView();

  @override
  State<_ExpenseClaimListView> createState() => _ExpenseClaimListViewState();
}

class _ExpenseClaimListViewState extends State<_ExpenseClaimListView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<ExpenseClaimBloc>().add(ExpenseClaimLoadMore());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create claim
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppScaling.space16),
            child: AppSearchField(
              hintText: 'Search claims...',
              debounce: AppConstants.searchDebounce,
              onChanged: (value) {
                context.read<ExpenseClaimBloc>().add(
                  ExpenseClaimSearched(value ?? ''),
                );
              },
            ),
          ),

          const ClaimStatusFilter(),

          Expanded(
            child: BlocConsumer<ExpenseClaimBloc, ExpenseClaimState>(
              listener: (context, state) {
                if (state.status.isFailure && state.claims.isNotEmpty) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.message ?? 'Something went wrong'),
                      ),
                    );
                }
              },
              builder: (context, state) {
                if (state.status.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status.isFailure && state.claims.isEmpty) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<ExpenseClaimBloc>().add(
                        ExpenseClaimRefreshed(),
                      );
                    },
                  );
                }

                if (state.claims.isEmpty) {
                  return const AppEmptyWidget(message: 'No claims found');
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ExpenseClaimBloc>().add(
                      ExpenseClaimRefreshed(),
                    );
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppScaling.space16),
                    itemCount:
                        state.claims.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.claims.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppScaling.space16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return ClaimItem(claim: state.claims[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
