import 'package:hive/hive.dart';

import '../../../../core/storage/hive_typeids.dart';
import '../../domine/enums/claim_status_enum.dart';
import '../../domine/enums/expense_category_enum.dart';

part 'claim_model.g.dart';

@HiveType(typeId: HiveTypeIds.claim)
class ClaimModel extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? employeeId;
  @HiveField(2)
  String? description;
  @HiveField(3)
  double? amount;
  @HiveField(4)
  DateTime? date;
  @HiveField(5)
  String? _categoryValue;
  ExpenseCategory? get category {
    if (_categoryValue == null) return null;
    for (final value in ExpenseCategory.values) {
      if (value.storageValue == _categoryValue) {
        return value;
      }
    }
    return null;
  }

  set category(ExpenseCategory? value) {
    _categoryValue = value?.storageValue;
  }

  @HiveField(6)
  String? _statusValue;
  ClaimStatus? get status {
    if (_statusValue == null) return null;
    for (final value in ClaimStatus.values) {
      if (value.storageValue == _statusValue) {
        return value;
      }
    }
    return null;
  }

  set status(ClaimStatus? value) {
    _statusValue = value?.storageValue;
  }

  @HiveField(7)
  String? receiptFileName;
  @HiveField(8)
  String? reviewerId;
  @HiveField(9)
  DateTime? reviewDate;
  @HiveField(10)
  String? reviewComments;
  @HiveField(11)
  DateTime? createdAt;

  ClaimModel({
    this.id,
    this.employeeId,
    this.description,
    this.amount,
    this.date,
    ExpenseCategory? category,
    ClaimStatus? status,
    this.receiptFileName,
    this.reviewerId,
    this.reviewDate,
    this.reviewComments,
    this.createdAt,
  }) {
    this.category = category;
    this.status = status;
  }

  ClaimModel copyWith({
    String? id,
    String? employeeId,
    String? description,
    double? amount,
    DateTime? date,
    ExpenseCategory? category,
    ClaimStatus? status,
    String? receiptFileName,
    String? reviewerId,
    DateTime? reviewDate,
    String? reviewComments,
    DateTime? createdAt,
  }) {
    return ClaimModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      status: status ?? this.status,
      receiptFileName: receiptFileName ?? this.receiptFileName,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewDate: reviewDate ?? this.reviewDate,
      reviewComments: reviewComments ?? this.reviewComments,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  ClaimModel withReview({
    required ClaimStatus status,
    String? reviewerId,
    String? comments,
  }) {
    final isPending = status.isPending;

    return ClaimModel(
      id: id,
      employeeId: employeeId,
      description: description,
      amount: amount,
      date: date,
      category: category,
      status: status,
      receiptFileName: receiptFileName,
      reviewerId: isPending ? null : reviewerId,
      reviewDate: isPending ? null : DateTime.now(),
      reviewComments: isPending ? null : comments,
      createdAt: createdAt,
    );
  }
}
