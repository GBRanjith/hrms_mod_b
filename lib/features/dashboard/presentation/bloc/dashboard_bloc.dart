import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/storage/preference_service.dart';
import '../../../claim/data/claim_repo.dart';
import '../../../employee/data/employee_repo.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardRefreshed>(_onRefreshed);

    _subscription = ClaimRepository.watchClaims().listen(
      (_) => add(DashboardRefreshed()),
    );
  }

  StreamSubscription? _subscription;

  void _onStarted(DashboardStarted event, Emitter<DashboardState> emit) {
    _load(emit);
  }

  void _onRefreshed(DashboardRefreshed event, Emitter<DashboardState> emit) {
    _load(emit);
  }

  void _load(Emitter<DashboardState> emit) {
    try {
      final employeesCount = EmployeeRepository.getEmployeesCount();
      final pendingClaims = ClaimRepository.getPendingCount();
      final approvedClaims = ClaimRepository.getApprovedAmount();
      final user = EmployeeRepository.getEmployeeByEmpId(
        PreferenceService.employeeId ?? "",
      );

      emit(
        state.copyWith(
          status: Status.success,
          employeeName: user?.name ?? "",
          totalEmployees: employeesCount,
          pendingClaims: pendingClaims,
          approvedThisMonth: approvedClaims,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Could not load the dashboard.',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
