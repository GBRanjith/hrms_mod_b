import '../../../../core/enums/sort_enum.dart';
import '../../data/models/expense_claim_model.dart';
import '../../domine/enums/claim_status_enum.dart';

abstract class ExpenseClaimEvent {}

class ExpenseClaimStarted extends ExpenseClaimEvent {}

class ExpenseClaimRefreshed extends ExpenseClaimEvent {}

class ExpenseClaimSearched extends ExpenseClaimEvent {
  final String search;
  ExpenseClaimSearched(this.search);
}

class ExpenseClaimStatusSelected extends ExpenseClaimEvent {
  final ClaimStatus? status;
  ExpenseClaimStatusSelected(this.status);
}

class ExpenseClaimSortChanged extends ExpenseClaimEvent {
  final Sort sort;
  ExpenseClaimSortChanged(this.sort);
}

class ExpenseClaimLoadMore extends ExpenseClaimEvent {}

class ExpenseClaimCreated extends ExpenseClaimEvent {
  final ExpenseClaimModel claim;
  ExpenseClaimCreated(this.claim);
}

class ExpenseClaimUpdated extends ExpenseClaimEvent {
  final ExpenseClaimModel claim;
  ExpenseClaimUpdated(this.claim);
}

class ExpenseClaimDeleted extends ExpenseClaimEvent {
  final String id;
  ExpenseClaimDeleted(this.id);
}
