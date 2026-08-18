import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/storage/preference_service.dart';
import '../../data/auth_repo.dart';
import '../../data/models/auth_input_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginOnChangeHidePassword>(_onLoginOnChangeHidePassword);
    on<LoginOnFieldChanged>(_onLoginOnFieldChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }
  Future<void> _onLoginOnChangeHidePassword(
    LoginOnChangeHidePassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(hidePassword: !state.hidePassword));
  }

  Future<void> _onLoginOnFieldChanged(
    LoginOnFieldChanged event,
    Emitter<AuthState> emit,
  ) async {
    final currentInput = state.input ?? AuthInputModel();
    final updatedInput = switch (event.field) {
      LoginField.userName => currentInput.copyWith(userName: event.value),
      LoginField.password => currentInput.copyWith(password: event.value),
    };

    emit(state.copyWith(input: updatedInput));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, message: null));
    try {
      final repoResult = await AuthRepository.login(event.loginInputModel);
      if (repoResult.isSuccess) {
        PreferenceService.isLoggedIn = true;
        PreferenceService.employeeId = event.loginInputModel.userName;
        emit(
          state.copyWith(
            status: Status.success,
            nextRoute: RouteNames.home,
            message: "Login successful",
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: Status.failure,
            nextRoute: null,
            message: "Invalid credentials",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: "Failed to login",
          nextRoute: null,
        ),
      );
    }
  }
}
