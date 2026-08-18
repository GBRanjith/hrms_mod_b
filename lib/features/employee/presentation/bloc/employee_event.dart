import '../../../employee/domine/enum/department_enum.dart';

abstract class EmployeeEvent {}

class EmployeeListStarted extends EmployeeEvent {}

class EmployeeListRefreshed extends EmployeeEvent {}

class EmployeeListSearched extends EmployeeEvent {
  final String search;

  EmployeeListSearched(this.search);
}

class EmployeeListDepartmentSelected extends EmployeeEvent {
  final Department? department;

  EmployeeListDepartmentSelected(this.department);
}

class EmployeeListFiltersCleared extends EmployeeEvent {}

class EmployeeListLoadMore extends EmployeeEvent {}
