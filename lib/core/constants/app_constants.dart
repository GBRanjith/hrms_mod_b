abstract final class AppConstants {
  static const String appName = 'Arche HRMS';
  static const String moduleName = 'Employee Directory & Expense Claims';

  // Demo credentials
  static const String demoEmployeeId = 'emp001';
  static const String demoPassword = 'Demo@123';

  // Delay after the last keystroke before a search is applied.
  static const Duration searchDebounce = Duration(milliseconds: 300);

  static const int receiptImageQuality = 82;

  static const double receiptMaxWidth = 1440;

  static const Duration splashDuration = Duration(seconds: 2);

  static const int defaultPageSize = 30;
}
