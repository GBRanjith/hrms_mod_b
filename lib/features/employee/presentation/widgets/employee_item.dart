import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_mod_b/app/router/route_names.dart';
import 'package:hrms_mod_b/features/employee/data/models/employee_model.dart';

import '../../../../core/theme/app_scaling.dart';

class EmployeeItem extends StatelessWidget {
  final EmployeeModel employee;
  const EmployeeItem({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppScaling.space8),
      ),
      margin: const EdgeInsets.only(bottom: AppScaling.space8),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          child: Text(
            employee.name?.isNotEmpty == true
                ? employee.name![0].toUpperCase()
                : '',
          ),
        ),
        title: Text(employee.name ?? '-', style: textTheme.titleMedium),
        subtitle: ListBody(
          children: [
            Text(employee.designation ?? '', style: textTheme.bodyMedium),
            const SizedBox(height: AppScaling.space4),
            Text(
              (employee.department?.label ?? '').toUpperCase(),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: colorScheme.outlineVariant,
        ),
        onTap: () {
          context.pushNamed(RouteNames.directoryDetail, extra: employee);
        },
      ),
    );
  }
}
