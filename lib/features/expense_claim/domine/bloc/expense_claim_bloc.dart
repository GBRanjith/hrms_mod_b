import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enums/status.dart';
import '../../data/expense_claim_repo.dart';
import 'expense_claim_event.dart';
import 'expense_claim_state.dart';

class ExpenseClaimBloc extends Bloc<ExpenseClaimEvent, ExpenseClaimState> {
  ExpenseClaimBloc() : super(const ExpenseClaimState()) {
    on<ExpenseClaimStarted>(_onStarted);
    on<ExpenseClaimRefreshed>(_onRefreshed);
    on<ExpenseClaimSearched>(_onSearched);
    on<ExpenseClaimStatusSelected>(_onStatusSelected);
    on<ExpenseClaimSortChanged>(_onSortChanged);
    on<ExpenseClaimLoadMore>(_onLoadMore);
    on<ExpenseClaimCreated>(_onCreated);
    on<ExpenseClaimUpdated>(_onUpdated);
    on<ExpenseClaimDeleted>(_onDeleted);

    _watchClaims();
  }

  StreamSubscription? _claimsSubscription;

  void _watchClaims() {
    _claimsSubscription = ExpenseClaimRepository.watchClaims().listen((_) {
      add(ExpenseClaimRefreshed());
    });
  }

  void _loadFirstPage(
    ExpenseClaimState nextState,
    Emitter<ExpenseClaimState> emit,
  ) {
    emit(
      nextState.copyWith(
        status: Status.loading,
        message: null,
        claims: [],
        hasMore: true,
        isLoadingMore: false,
      ),
    );

    try {
      final claims = ExpenseClaimRepository.getClaims(
        search: nextState.search,
        status: nextState.claimStatus,
        sort: nextState.sort,
        limit: AppConstants.defaultPageSize,
        offset: 0,
      );

      emit(
        nextState.copyWith(
          status: Status.success,
          claims: claims,
          hasMore: claims.length == AppConstants.defaultPageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        nextState.copyWith(
          status: Status.failure,
          message: 'Failed to load expense claims.',
        ),
      );
    }
  }

  void _onStarted(ExpenseClaimStarted event, Emitter<ExpenseClaimState> emit) {
    _loadFirstPage(state, emit);
  }

  void _onRefreshed(
    ExpenseClaimRefreshed event,
    Emitter<ExpenseClaimState> emit,
  ) {
    _loadFirstPage(state, emit);
  }

  void _onSearched(
    ExpenseClaimSearched event,
    Emitter<ExpenseClaimState> emit,
  ) {
    _loadFirstPage(state.copyWith(search: event.search.trim()), emit);
  }

  void _onStatusSelected(
    ExpenseClaimStatusSelected event,
    Emitter<ExpenseClaimState> emit,
  ) {
    final nextState = event.status == null
        ? state.clearStatus()
        : state.copyWith(claimStatus: event.status);

    _loadFirstPage(nextState, emit);
  }

  void _onSortChanged(
    ExpenseClaimSortChanged event,
    Emitter<ExpenseClaimState> emit,
  ) {
    _loadFirstPage(state.copyWith(sort: event.sort), emit);
  }

  void _onLoadMore(
    ExpenseClaimLoadMore event,
    Emitter<ExpenseClaimState> emit,
  ) {
    if (!state.hasMore || state.isLoadingMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, message: null));

    try {
      final claims = ExpenseClaimRepository.getClaims(
        search: state.search,
        status: state.claimStatus,
        sort: state.sort,
        limit: AppConstants.defaultPageSize,
        offset: state.claims.length,
      );

      emit(
        state.copyWith(
          status: Status.success,
          claims: [...state.claims, ...claims],
          hasMore: claims.length == AppConstants.defaultPageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          message: 'Failed to load more claims.',
        ),
      );
    }
  }

  Future<void> _onCreated(
    ExpenseClaimCreated event,
    Emitter<ExpenseClaimState> emit,
  ) async {
    try {
      final result = await ExpenseClaimRepository.createClaim(event.claim);

      if (result.status.isFailure) {
        emit(state.copyWith(status: Status.failure, message: result.message));
        return;
      }
      emit(state.copyWith(status: Status.success, message: result.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Failed to create claim.',
        ),
      );
    }
  }

  Future<void> _onUpdated(
    ExpenseClaimUpdated event,
    Emitter<ExpenseClaimState> emit,
  ) async {
    try {
      final result = await ExpenseClaimRepository.updateClaim(event.claim);

      if (result.status.isFailure) {
        emit(state.copyWith(status: Status.failure, message: result.message));
        return;
      }

      emit(state.copyWith(status: Status.success, message: result.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Failed to update claim.',
        ),
      );
    }
  }

  Future<void> _onDeleted(
    ExpenseClaimDeleted event,
    Emitter<ExpenseClaimState> emit,
  ) async {
    try {
      final result = await ExpenseClaimRepository.deleteClaim(event.id);

      if (result.status.isFailure) {
        emit(state.copyWith(status: Status.failure, message: result.message));
        return;
      }

      emit(state.copyWith(status: Status.success, message: result.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Failed to delete claim.',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _claimsSubscription?.cancel();
    return super.close();
  }
}
