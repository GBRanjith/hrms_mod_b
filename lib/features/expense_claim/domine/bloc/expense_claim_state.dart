import 'package:equatable/equatable.dart';
import '../../../../core/enums/sort_enum.dart';
import '../../../../core/enums/status.dart';
import '../../data/models/expense_claim_model.dart';
import '../enums/claim_status_enum.dart';

class ExpenseClaimState extends Equatable {
  final Status status;
  final String? message;
  final List<ExpenseClaimModel> claims;
  final String search;
  final ClaimStatus? claimStatus;
  final Sort sort;
  final bool hasMore;
  final bool isLoadingMore;

  const ExpenseClaimState({
    this.status = Status.initial,
    this.message,
    this.claims = const [],
    this.search = '',
    this.claimStatus,
    this.sort = Sort.newestFirst,
    this.hasMore = true,
    this.isLoadingMore = false,
  });
  ExpenseClaimState clearStatus() {
    return ExpenseClaimState(
      status: status,
      message: message,
      claims: claims,
      search: search,
      claimStatus: null,
      sort: sort,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
    );
  }

  ExpenseClaimState copyWith({
    Status? status,
    String? message,
    List<ExpenseClaimModel>? claims,
    String? search,
    ClaimStatus? claimStatus,
    Sort? sort,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ExpenseClaimState(
      status: status ?? this.status,
      message: message,
      claims: claims ?? this.claims,
      search: search ?? this.search,
      claimStatus: claimStatus ?? this.claimStatus,
      sort: sort ?? this.sort,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    claims,
    search,
    claimStatus,
    sort,
    hasMore,
    isLoadingMore,
  ];
}
