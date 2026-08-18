import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/employee/data/models/employee_model.dart';
import '../../features/expense_claim/data/models/expense_claim_model.dart';
import 'hive_boxes.dart';

abstract final class DatabaseInitializer {
  static Future<void> initialize() async {
    await _initializeHive();
    _registerAdapters();
    await _openBoxes();
  }

  static Future<void> _initializeHive() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }

  static void _registerAdapters() {
    Hive.registerAdapter(EmployeeModelAdapter());
    Hive.registerAdapter(ExpenseClaimModelAdapter());
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<EmployeeModel>(HiveBoxes.employees);
    await Hive.openBox<ExpenseClaimModel>(HiveBoxes.claims);
  }
}
