enum ExpenseCategory {
  travel,
  food,
  accommodation,
  clientVisit,
  other;

  String get storageValue => switch (this) {
    ExpenseCategory.travel => 'travel',
    ExpenseCategory.food => 'food',
    ExpenseCategory.accommodation => 'accommodation',
    ExpenseCategory.clientVisit => 'client_visit',
    ExpenseCategory.other => 'other',
  };

  /// Human-readable label for UI display.
  String get label => switch (this) {
    ExpenseCategory.travel => 'Travel',
    ExpenseCategory.food => 'Food',
    ExpenseCategory.accommodation => 'Accommodation',
    ExpenseCategory.clientVisit => 'Client Visit',
    ExpenseCategory.other => 'Other',
  };

  static ExpenseCategory fromStorage(String? value) {
    for (final category in ExpenseCategory.values) {
      if (category.storageValue == value) return category;
    }
    return ExpenseCategory.other;
  }
}
