import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/enums/status.dart';
import '../../data/employee_repo.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(const EmployeeState()) {
    on<EmployeeListStarted>(_onStarted);
    on<EmployeeListRefreshed>(_onRefreshed);
    on<EmployeeListSearched>(_onSearched);
    on<EmployeeListDepartmentSelected>(_onDepartmentSelected);
    on<EmployeeListFiltersCleared>(_onFiltersCleared);
    on<EmployeeListLoadMore>(_onLoadMore);
  }

  void _loadFirstPage(EmployeeState nextState, Emitter<EmployeeState> emit) {
    emit(
      nextState.copyWith(
        status: Status.loading,
        message: null,
        employees: [],
        hasMore: true,
        isLoadingMore: false,
      ),
    );

    try {
      final employees = EmployeeRepository.getEmployees(
        search: nextState.search,
        department: nextState.department,
        limit: AppConstants.defaultPageSize,
        offset: 0,
      );

      emit(
        nextState.copyWith(
          status: Status.success,
          employees: employees,
          hasMore: employees.length == AppConstants.defaultPageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        nextState.copyWith(
          status: Status.failure,
          message: 'Failed to load employees. Please try again later.',
          isLoadingMore: false,
        ),
      );
    }
  }

  void _onStarted(EmployeeListStarted event, Emitter<EmployeeState> emit) {
    _loadFirstPage(state, emit);
  }

  void _onRefreshed(EmployeeListRefreshed event, Emitter<EmployeeState> emit) {
    _loadFirstPage(state, emit);
  }

  void _onSearched(EmployeeListSearched event, Emitter<EmployeeState> emit) {
    _loadFirstPage(state.copyWith(search: event.search.trim()), emit);
  }

  void _onDepartmentSelected(
    EmployeeListDepartmentSelected event,
    Emitter<EmployeeState> emit,
  ) {
    final nextState = event.department == null
        ? state.clearDepartment()
        : state.copyWith(department: event.department);

    _loadFirstPage(nextState, emit);
  }

  void _onFiltersCleared(
    EmployeeListFiltersCleared event,
    Emitter<EmployeeState> emit,
  ) {
    _loadFirstPage(state.clearDepartment().copyWith(search: ''), emit);
  }

  void _onLoadMore(EmployeeListLoadMore event, Emitter<EmployeeState> emit) {
    if (!state.hasMore || state.isLoadingMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, message: null));

    try {
      final employees = EmployeeRepository.getEmployees(
        search: state.search,
        department: state.department,
        limit: AppConstants.defaultPageSize,
        offset: state.employees.length,
      );

      emit(
        state.copyWith(
          status: Status.success,
          employees: [...state.employees, ...employees],
          hasMore: employees.length == AppConstants.defaultPageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          message: 'Failed to load more employees.',
        ),
      );
    }
  }
}
