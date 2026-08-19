import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get toShortDate => DateFormat('MMMM d, yyyy').format(this);

  DateTime get dateOnly => DateTime(year, month, day);

  bool isSameMonthAs(DateTime other) =>
      year == other.year && month == other.month;

  String get relativeLabel {
    final days = DateTime.now().dateOnly.difference(dateOnly).inDays;
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    if (days > 1 && days < 7) return '$days days ago';
    return toShortDate;
  }
}
