import 'package:equatable/equatable.dart';

import '../../../../core/enums/status.dart';

class SplashState extends Equatable {
  final Status status;
  final String? message;
  final String? nextRoute;

  const SplashState({
    this.status = Status.initial,
    this.message,
    this.nextRoute,
  });

  SplashState copyWith({
    Status? status,
    String? message,
    String? nextRoute,
  }) {
    return SplashState(
      status: status ?? this.status,
      message: message ?? this.message,
      nextRoute: nextRoute ?? this.nextRoute,
    );
  }

  @override
  List<Object?> get props => [status, message, nextRoute];
}