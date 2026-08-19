import '../../../../core/enums/sort_enum.dart';
import '../../data/models/claim_model.dart';
import '../../domine/enums/claim_status_enum.dart';

abstract class ClaimEvent {}

class ClaimStarted extends ClaimEvent {}

class ClaimRefreshed extends ClaimEvent {}

class ClaimSearched extends ClaimEvent {
  final String search;
  ClaimSearched(this.search);
}

class ClaimStatusSelected extends ClaimEvent {
  final ClaimStatus? status;
  ClaimStatusSelected(this.status);
}

class ClaimSortChanged extends ClaimEvent {
  final Sort sort;
  ClaimSortChanged(this.sort);
}

class ClaimLoadMore extends ClaimEvent {}

class ClaimCreated extends ClaimEvent {
  final ClaimModel claim;
  ClaimCreated(this.claim);
}

class ClaimUpdated extends ClaimEvent {
  final ClaimModel claim;
  ClaimUpdated(this.claim);
}

class ClaimDeleted extends ClaimEvent {
  final String id;
  ClaimDeleted(this.id);
}

class ClaimReviewed extends ClaimEvent {
  final String id;
  final ClaimStatus status;
  final String? comments;
  ClaimReviewed({required this.id, required this.status, this.comments});
}
