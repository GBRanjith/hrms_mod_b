import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../../../core/storage/hive_boxes.dart';
import '../domine/enum/department_enum.dart';
import 'models/employee_model.dart';

class EmployeeRepository {
  const EmployeeRepository();
  static Box<EmployeeModel> get _employeeBox =>
      Hive.box<EmployeeModel>(HiveBoxes.employees);

  static const String empJsonFilePath = "assets/seeds/employees.json";

  static Future<void> saveAll() async {
    await _employeeBox.clear();
    final rawData = await rootBundle.loadString(empJsonFilePath);
    final jsonDecodedItems = jsonDecode(rawData) as List;
    final items = jsonDecodedItems
        .map((item) => EmployeeModel.fromJson(item as Map<String, dynamic>))
        .toList();
    await _employeeBox.addAll(items);
  }

  static List<EmployeeModel> getEmployees({
    String? search,
    Department? department,
    int? limit,
    int? offset,
  }) {
    final query = search?.trim().toLowerCase() ?? '';
    final start = offset != null && offset > 0 ? offset : 0;

    final employees = _employeeBox.values.where((employee) {
      final matchesSearch =
          query.isEmpty ||
          (employee.name?.toLowerCase().contains(query) ?? false);

      final matchesDepartment =
          department == null || employee.department == department;

      return matchesSearch && matchesDepartment;
    }).toList()..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));

    return employees.skip(start).take(limit ?? employees.length).toList();
  }

  EmployeeModel? getEmployeeByEmpId(String id) {
    return _employeeBox.get(id);
  }
}
