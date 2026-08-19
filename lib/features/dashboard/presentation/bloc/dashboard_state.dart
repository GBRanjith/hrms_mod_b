import 'package:equatable/equatable.dart';

import '../../../../core/enums/status.dart';

class DashboardState extends Equatable {
  final Status status;
  final String? message;
  final String employeeName;
  final int totalEmployees;
  final int pendingClaims;
  final double approvedThisMonth;

  const DashboardState({
    this.status = Status.initial,
    this.message,
    this.employeeName = '',
    this.totalEmployees = 0,
    this.pendingClaims = 0,
    this.approvedThisMonth = 0,
  });

  DashboardState copyWith({
    Status? status,
    String? message,
    String? employeeName,
    int? totalEmployees,
    int? pendingClaims,
    double? approvedThisMonth,
  }) {
    return DashboardState(
      status: status ?? this.status,
      // Transient by design: cleared unless explicitly set.
      message: message,
      employeeName: employeeName ?? this.employeeName,
      totalEmployees: totalEmployees ?? this.totalEmployees,
      pendingClaims: pendingClaims ?? this.pendingClaims,
      approvedThisMonth: approvedThisMonth ?? this.approvedThisMonth,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    employeeName,
    totalEmployees,
    pendingClaims,
    approvedThisMonth,
  ];
}
