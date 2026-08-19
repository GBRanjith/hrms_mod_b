import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/storage/preference_service.dart';
import '../../../../core/storage/receipt_storage.dart';
import '../../data/claim_repo.dart';
import '../../data/models/claim_model.dart';
import '../../domain/enums/expense_category_enum.dart';
import 'claim_form_event.dart';
import 'claim_form_state.dart';

class ClaimFormBloc extends Bloc<ClaimFormEvent, ClaimFormState> {
  ClaimFormBloc({ImagePicker? imagePicker}) : super(ClaimFormState()) {
    on<ClaimFormStarted>(_onStarted);
    on<ClaimFormCategoryChanged>(_onCategoryChanged);
    on<ClaimFormDateChanged>(_onDateChanged);
    on<ClaimFormReceiptChanged>(_onReceiptChanged);
    on<ClaimFormReceiptRemoved>(_onReceiptRemoved);
    on<ClaimFormSubmitted>(_onSubmitted);
    on<ClaimFormDeleted>(_onDeleted);
  }

  void _onStarted(ClaimFormStarted event, Emitter<ClaimFormState> emit) {
    if (event.claimId == null) {
      emit(
        ClaimFormState(
          claim: ClaimModel(
            id: const Uuid().v4(),
            employeeId: PreferenceService.employeeId,
            category: ExpenseCategory.values.first,
            date: DateTime.now(),
          ),
        ),
      );
      return;
    }

    final existing = ClaimRepository.getClaimById(event.claimId!);
    if (existing == null) {
      emit(
        ClaimFormState(
          status: Status.failure,
          message: 'That claim no longer exists.',
        ),
      );
      return;
    }

    emit(ClaimFormState(isEditing: true, claim: existing));
  }

  void _onCategoryChanged(
    ClaimFormCategoryChanged event,
    Emitter<ClaimFormState> emit,
  ) {
    emit(state.copyWith(claim: state.claim.copyWith(category: event.category)));
  }

  void _onDateChanged(
    ClaimFormDateChanged event,
    Emitter<ClaimFormState> emit,
  ) {
    emit(state.copyWith(claim: state.claim.copyWith(date: event.date)));
  }

  void _onReceiptChanged(
    ClaimFormReceiptChanged event,
    Emitter<ClaimFormState> emit,
  ) {
    if (event.file == null) {
      emit(
        state.copyWith(
          clearPickedReceipt: true,
          claim: state.claim.copyWith(clearReceiptFileName: true),
        ),
      );
      return;
    }

    emit(state.copyWith(pickedReceipt: event.file));
  }

  void _onReceiptRemoved(
    ClaimFormReceiptRemoved event,
    Emitter<ClaimFormState> emit,
  ) {
    emit(
      state.copyWith(
        clearPickedReceipt: true,
        claim: state.claim.copyWith(receiptFileName: null),
      ),
    );
  }

  Future<void> _onSubmitted(
    ClaimFormSubmitted event,
    Emitter<ClaimFormState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final input = state.claim.copyWith(
        amount: event.amount,
        description: event.description,
        receiptFileName: await _resolveReceiptFileName(),
      );

      final result = state.isEditing
          ? await ClaimRepository.updateClaim(input)
          : await ClaimRepository.createClaim(input);

      emit(state.copyWith(status: result.status, message: result.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Could not save the claim. Please try again.',
        ),
      );
    }
  }

  Future<String?> _resolveReceiptFileName() async {
    if (state.pickedReceipt == null) return state.claim.receiptFileName;
    return ReceiptStorage.save(state.pickedReceipt!, claimId: state.claim.id!);
  }

  Future<void> _onDeleted(
    ClaimFormDeleted event,
    Emitter<ClaimFormState> emit,
  ) async {
    if (state.claim.id == null) return;

    emit(state.copyWith(status: Status.loading));

    final result = await ClaimRepository.deleteClaim(state.claim.id!);
    emit(state.copyWith(status: result.status, message: result.message));
  }
}
