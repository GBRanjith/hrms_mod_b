import 'package:flutter/material.dart';
import 'package:hrms_mod_b/core/constants/app_constants.dart';
import 'package:hrms_mod_b/core/widgets/app_search_field.dart';

import '../../../../core/theme/app_scaling.dart';
import '../../../../core/widgets/app_filter_chips.dart';
import '../../domine/enum/department_enum.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppScaling.space16),
            child: AppSearchField(
              hintText: "Search name...",
              onChanged: (value) {},
              debounce: AppConstants.searchDebounce,
            ),
          ),
          AppFilterChips<String>(
            items: Department.values.map((e) => e.label).toList(),
            selected: null,
            onSelected: (department) {},
          ),
        ],
      ),
    );
  }
}
