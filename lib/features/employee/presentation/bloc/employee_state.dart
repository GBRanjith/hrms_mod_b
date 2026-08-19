import 'package:equatable/equatable.dart';
import '../../../../core/enums/status.dart';
import '../../data/models/employee_model.dart';
import '../../domain/enum/department_enum.dart';

class EmployeeState extends Equatable {
  final Status status;
  final String? message;
  final List<EmployeeModel> employees;
  final String search;
  final Department? department;
  final bool hasMore;
  final bool isLoadingMore;

  const EmployeeState({
    this.status = Status.initial,
    this.message,
    this.employees = const [],
    this.search = '',
    this.department,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  EmployeeState clearDepartment() {
    return EmployeeState(
      status: status,
      message: message,
      employees: employees,
      search: search,
      department: null,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
    );
  }

  EmployeeState copyWith({
    Status? status,
    String? message,
    List<EmployeeModel>? employees,
    String? search,
    Department? department,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return EmployeeState(
      status: status ?? this.status,
      message: message,
      employees: employees ?? this.employees,
      search: search ?? this.search,
      department: department ?? this.department,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    employees,
    search,
    department,
    hasMore,
    isLoadingMore,
  ];
}
