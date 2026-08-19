import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enums/status.dart';
import '../../data/claim_repo.dart';
import 'claim_event.dart';
import 'claim_state.dart';

class ClaimBloc extends Bloc<ClaimEvent, ClaimState> {
  ClaimBloc() : super(const ClaimState()) {
    on<ClaimStarted>(_onStarted);
    on<ClaimRefreshed>(_onRefreshed);
    on<ClaimSearched>(_onSearched);
    on<ClaimStatusSelected>(_onStatusSelected);
    on<ClaimSortChanged>(_onSortChanged);
    on<ClaimLoadMore>(_onLoadMore);
    on<ClaimCreated>(_onCreated);
    on<ClaimUpdated>(_onUpdated);
    on<ClaimDeleted>(_onDeleted);
    on<ClaimReviewed>(_onReviewed);

    _watchClaims();
  }

  StreamSubscription? _claimsSubscription;

  void _watchClaims() {
    _claimsSubscription = ClaimRepository.watchClaims().listen((_) {
      add(ClaimRefreshed());
    });
  }

  void _loadFirstPage(ClaimState nextState, Emitter<ClaimState> emit) {
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
      final claims = ClaimRepository.getClaims(
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

  void _onStarted(ClaimStarted event, Emitter<ClaimState> emit) {
    _loadFirstPage(state, emit);
  }

  void _onRefreshed(ClaimRefreshed event, Emitter<ClaimState> emit) {
    _loadFirstPage(state, emit);
  }

  void _onSearched(ClaimSearched event, Emitter<ClaimState> emit) {
    _loadFirstPage(state.copyWith(search: event.search.trim()), emit);
  }

  void _onStatusSelected(ClaimStatusSelected event, Emitter<ClaimState> emit) {
    final nextState = event.status == null
        ? state.clearStatus()
        : state.copyWith(claimStatus: event.status);

    _loadFirstPage(nextState, emit);
  }

  void _onSortChanged(ClaimSortChanged event, Emitter<ClaimState> emit) {
    _loadFirstPage(state.copyWith(sort: event.sort), emit);
  }

  void _onLoadMore(ClaimLoadMore event, Emitter<ClaimState> emit) {
    if (!state.hasMore || state.isLoadingMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, message: null));

    try {
      final claims = ClaimRepository.getClaims(
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

  Future<void> _onCreated(ClaimCreated event, Emitter<ClaimState> emit) async {
    try {
      final result = await ClaimRepository.createClaim(event.claim);

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

  Future<void> _onUpdated(ClaimUpdated event, Emitter<ClaimState> emit) async {
    try {
      final result = await ClaimRepository.updateClaim(event.claim);

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

  Future<void> _onDeleted(ClaimDeleted event, Emitter<ClaimState> emit) async {
    try {
      final result = await ClaimRepository.deleteClaim(event.id);

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

  Future<void> _onReviewed(
    ClaimReviewed event,
    Emitter<ClaimState> emit,
  ) async {
    final result = await ClaimRepository.reviewClaim(
      claimId: event.id,
      status: event.status,
      comments: event.comments,
    );
    emit(state.copyWith(message: result.message));
  }

  @override
  Future<void> close() {
    _claimsSubscription?.cancel();
    return super.close();
  }
}
