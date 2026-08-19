import 'package:intl/intl.dart';

extension CurrencyFormatting on num {
  String formatAmount({bool symbol = true}) {
    try {
      double amount = toStringAsFixed(2).toString().asDouble() ?? 0;
      int decimalDigits = this % 1 == 0 ? 0 : 2;
      NumberFormat currencyFormat = NumberFormat.currency(
        locale: 'en_IN',
        symbol: symbol ? '\u20B9 ' : '',
        decimalDigits: decimalDigits,
      );
      return currencyFormat.format(amount).trim();
    } catch (e) {
      return symbol ? '\u20B9 $this' : '$this';
    }
  }
}

extension StringCurrencyFormatting on String {
  String formatAmount({bool symbol = true}) {
    final value = toString().asDouble();
    if (value == null) return this;
    return value.formatAmount(symbol: symbol);
  }
}

extension DynamicToStringExtension on dynamic {
  double? asDouble() {
    if (this == null) return null;
    if (this is double) return this as double;
    if (this is int) return (this as int).toDouble();
    if (this is String) {
      return double.tryParse((this as String).replaceAll(',', '').trim());
    }
    return null;
  }
}
