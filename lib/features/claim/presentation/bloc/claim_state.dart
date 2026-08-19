import 'package:equatable/equatable.dart';
import '../../../../core/enums/sort_enum.dart';
import '../../../../core/enums/status.dart';
import '../../data/models/claim_model.dart';
import '../../domine/enums/claim_status_enum.dart';

class ClaimState extends Equatable {
  final Status status;
  final String? message;
  final List<ClaimModel> claims;
  final String search;
  final ClaimStatus? claimStatus;
  final Sort sort;
  final bool hasMore;
  final bool isLoadingMore;

  const ClaimState({
    this.status = Status.initial,
    this.message,
    this.claims = const [],
    this.search = '',
    this.claimStatus,
    this.sort = Sort.newestFirst,
    this.hasMore = true,
    this.isLoadingMore = false,
  });
  ClaimState clearStatus() {
    return ClaimState(
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

  bool get hasFilters => search.isNotEmpty || claimStatus != null;
  ClaimState copyWith({
    Status? status,
    String? message,
    List<ClaimModel>? claims,
    String? search,
    ClaimStatus? claimStatus,
    Sort? sort,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ClaimState(
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
