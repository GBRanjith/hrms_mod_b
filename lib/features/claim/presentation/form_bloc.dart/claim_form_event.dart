import 'dart:io';

import '../../domine/enums/expense_category_enum.dart';

abstract class ClaimFormEvent {}

class ClaimFormStarted extends ClaimFormEvent {
  final String? claimId;
  ClaimFormStarted({this.claimId});
}

class ClaimFormCategoryChanged extends ClaimFormEvent {
  final ExpenseCategory category;
  ClaimFormCategoryChanged(this.category);
}

class ClaimFormDateChanged extends ClaimFormEvent {
  final DateTime date;
  ClaimFormDateChanged(this.date);
}


class ClaimFormReceiptChanged extends ClaimFormEvent {
  final File? file;
  ClaimFormReceiptChanged(this.file);
}

class ClaimFormReceiptRemoved extends ClaimFormEvent {}

class ClaimFormSubmitted extends ClaimFormEvent {
  final double amount;
  final String description;
  ClaimFormSubmitted({required this.amount, required this.description});
}


class ClaimFormDeleted extends ClaimFormEvent {}