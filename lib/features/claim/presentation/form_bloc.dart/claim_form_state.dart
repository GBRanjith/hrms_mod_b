import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../../core/enums/status.dart';
import '../../data/models/claim_model.dart';
import '../../domain/enums/expense_category_enum.dart';

class ClaimFormState extends Equatable {
  final Status status;
  final String? message;
  final ClaimModel claim;
  final File? pickedReceipt;
  final bool isEditing;

  ClaimFormState({
    this.status = Status.initial,
    this.message,
    ClaimModel? claim,
    this.pickedReceipt,
    this.isEditing = false,
  }) : claim = claim ?? ClaimModel();

  ExpenseCategory get category => claim.category ?? ExpenseCategory.travel;

  DateTime get date => claim.date ?? DateTime.now();

  bool get hasReceipt =>
      pickedReceipt != null ||
      (claim.receiptFileName != null && claim.receiptFileName!.isNotEmpty);

  ClaimFormState copyWith({
    Status? status,
    String? message,
    ClaimModel? claim,
    File? pickedReceipt,
    bool clearPickedReceipt = false,
    String? receiptError,
    bool? isEditing,
  }) {
    return ClaimFormState(
      status: status ?? this.status,
      message: message,
      claim: claim ?? this.claim,
      pickedReceipt: clearPickedReceipt
          ? null
          : (pickedReceipt ?? this.pickedReceipt),
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    claim.id,
    claim.category,
    claim.amount,
    claim.date,
    claim.description,
    claim.receiptFileName,
    pickedReceipt?.path,
    isEditing,
  ];
}
