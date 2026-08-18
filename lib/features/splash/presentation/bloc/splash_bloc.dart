import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/storage/preference_service.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await Future<void>.delayed(AppConstants.splashDuration);
      final String nextRouteName = PreferenceService.isLoggedIn
          ? RouteNames.home
          : RouteNames.login;
      emit(state.copyWith(status: Status.success, nextRoute: nextRouteName));
    } catch (e) {
      emit(
        state.copyWith(status: Status.failure, message: "Failed to load App"),
      );
    }
  }
}
