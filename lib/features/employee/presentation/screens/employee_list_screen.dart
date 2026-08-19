import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms_mod_b/core/constants/app_constants.dart';
import 'package:hrms_mod_b/core/theme/app_scaling.dart';
import 'package:hrms_mod_b/core/widgets/app_empty_widget.dart';
import 'package:hrms_mod_b/core/widgets/app_error_widget.dart';
import 'package:hrms_mod_b/core/widgets/app_search_field.dart';

import '../../../../core/widgets/logout_button.dart';
import '../../../../core/widgets/theme_switch_button.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../widgets/department_filter.dart';
import '../widgets/employee_item.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeBloc()..add(EmployeeListStarted()),
      child: const _EmployeeListView(),
    );
  }
}

class _EmployeeListView extends StatefulWidget {
  const _EmployeeListView();

  @override
  State<_EmployeeListView> createState() => _EmployeeListViewState();
}

class _EmployeeListViewState extends State<_EmployeeListView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<EmployeeBloc>().add(EmployeeListLoadMore());
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
        title: const Text("Employee Directory"),
        actions: const [LogoutButton()],
        leading: const ThemeSwitchButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppScaling.space16),
            child: AppSearchField(
              hintText: 'Search name...',
              debounce: AppConstants.searchDebounce,
              onChanged: (value) {
                context.read<EmployeeBloc>().add(
                  EmployeeListSearched(value ?? ''),
                );
              },
            ),
          ),

          const DepartmentFilter(),

          Expanded(
            child: BlocConsumer<EmployeeBloc, EmployeeState>(
              listener: (context, state) {
                if (state.status.isFailure && state.employees.isNotEmpty) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message ?? 'Failed to load employees',
                        ),
                      ),
                    );
                }
              },
              builder: (context, state) {
                if (state.status.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status.isFailure && state.employees.isEmpty) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<EmployeeBloc>().add(EmployeeListRefreshed());
                    },
                  );
                }

                if (state.employees.isEmpty) {
                  return const AppEmptyWidget(message: 'No employees found');
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<EmployeeBloc>().add(EmployeeListRefreshed());
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppScaling.space16,
                    ),
                    itemCount:
                        state.employees.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.employees.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppScaling.space16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return EmployeeItem(employee: state.employees[index]);
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
