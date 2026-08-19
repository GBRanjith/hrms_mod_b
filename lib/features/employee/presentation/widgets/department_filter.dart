import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_filter_chips.dart';
import '../../domain/enum/department_enum.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';

class DepartmentFilter extends StatelessWidget {
  const DepartmentFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      buildWhen: (previous, current) =>
          previous.department != current.department,
      builder: (context, state) {
        return AppFilterChips<String>(
          items: Department.values
              .map((department) => department.label)
              .toList(),
          selected: state.department?.label,
          onSelected: (label) {
            final department = label == null
                ? null
                : Department.values.firstWhere((item) => item.label == label);

            context.read<EmployeeBloc>().add(
              EmployeeListDepartmentSelected(department),
            );
          },
        );
      },
    );
  }
}
