import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/employee/data/models/employee_model.dart';
import '../../features/claim/data/models/claim_model.dart';
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
    Hive.registerAdapter(ClaimModelAdapter());
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<EmployeeModel>(HiveBoxes.employees);
    await Hive.openBox<ClaimModel>(HiveBoxes.claims);
  }

  static Future<void> clearAllData() async {
    try {
      await Hive.box<EmployeeModel>(HiveBoxes.employees).clear();
      await Hive.box<ClaimModel>(HiveBoxes.claims).clear();
    } catch (_) {}
  }
}
