import 'package:hive/hive.dart';
import '../../../../core/storage/hive_typeids.dart';
import '../../domine/enum/department_enum.dart';

part 'employee_model.g.dart';

@HiveType(typeId: HiveTypeIds.employee)
class EmployeeModel extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? phoneNumber;
  @HiveField(4)
  String? designation;
  Department? department;
  @HiveField(5)
  String? _departmentValue;
  @HiveField(6)
  String? reportingManager;
  @HiveField(7)
  DateTime? dateOfJoining;


  EmployeeModel({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.designation,
    this.department,
    this.reportingManager,
    this.dateOfJoining,
  }) {
    _departmentValue = department?.storageValue;
  }

  EmployeeModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? designation,
    Department? department,
    String? reportingManager,
    DateTime? dateOfJoining,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      designation: designation ?? this.designation,
      department: department ?? this.department,
      reportingManager: reportingManager ?? this.reportingManager,
      dateOfJoining: dateOfJoining ?? this.dateOfJoining,
    );
  }

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    designation = json['designation'];
    _departmentValue = json['department'];
    department = Department.fromStorage(_departmentValue);
    reportingManager = json['reportingManager'];
    dateOfJoining = DateTime.tryParse(json['dateOfJoining'] ?? '');
  }
}
