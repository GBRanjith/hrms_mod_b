import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../storage/preference_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeStarted>(_onStarted);
    on<ThemeToggled>(_onToggled);
  }

  void _onStarted(ThemeStarted event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: _fromStorage(PreferenceService.themeMode)));
  }

  void _onToggled(ThemeToggled event, Emitter<ThemeState> emit) {
    final next = state.isDark ? ThemeMode.light : ThemeMode.dark;
    PreferenceService.themeMode = next.name;
    emit(state.copyWith(themeMode: next));
  }

  ThemeMode _fromStorage(String value) => switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}
