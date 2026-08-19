import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_mod_b/features/claim/presentation/widgets/claim_sort_button.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_scaling.dart';
import '../../../../core/widgets/app_empty_widget.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/logout_button.dart';
import '../bloc/claim_bloc.dart';
import '../bloc/claim_event.dart';
import '../bloc/claim_state.dart';
import '../widgets/claim_item.dart';
import '../widgets/claim_review_sheet.dart';
import '../widgets/claim_status_filter.dart';

class ClaimListScreen extends StatelessWidget {
  const ClaimListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClaimBloc()..add(ClaimStarted()),
      child: const _ClaimListView(),
    );
  }
}

class _ClaimListView extends StatefulWidget {
  const _ClaimListView();

  @override
  State<_ClaimListView> createState() => _ClaimListViewState();
}

class _ClaimListViewState extends State<_ClaimListView> {
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
      context.read<ClaimBloc>().add(ClaimLoadMore());
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
      appBar: AppBar(
        title: const Text("My Claims"),
        actions: const [LogoutButton()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(RouteNames.createClaim);
        },
        icon: const Icon(Icons.add),
        label: const Text('New claim'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppScaling.space16),
            child: AppSearchField(
              hintText: 'Search claims...',
              debounce: AppConstants.searchDebounce,
              onChanged: (value) =>
                  context.read<ClaimBloc>().add(ClaimSearched(value ?? '')),
            ),
          ),

          Row(
            children: [
              Expanded(child: const ClaimStatusFilter()),
              ClaimSortButton(),
            ],
          ),
          Expanded(
            child: BlocConsumer<ClaimBloc, ClaimState>(
              listenWhen: (previous, current) =>
                  current.message != null &&
                  previous.message != current.message,
              listener: (context, state) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message!)));
              },
              builder: (context, state) {
                if (state.status.isLoading && state.claims.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status.isFailure && state.claims.isEmpty) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () =>
                        context.read<ClaimBloc>().add(ClaimRefreshed()),
                  );
                }

                if (state.claims.isEmpty) {
                  return AppEmptyWidget(
                    message: state.hasFilters
                        ? 'No claims found.'
                        : 'No claims yet. Tap + to file one.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      context.read<ClaimBloc>().add(ClaimRefreshed()),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      AppScaling.space16,
                      AppScaling.space8,
                      AppScaling.space16,
                      AppScaling.space40 * 2,
                    ),
                    itemCount:
                        state.claims.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.claims.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppScaling.space16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final claim = state.claims[index];
                      return ClaimItem(
                        claim: claim,
                        onTap: () {
                          context.pushNamed(
                            RouteNames.claimDetail,
                            pathParameters: {'id': claim.id!},
                          );
                        },
                        onLongPress: () =>
                            showReviewSheet(context: context, claim: claim),
                      );
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
