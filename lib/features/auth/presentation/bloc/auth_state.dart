import 'package:equatable/equatable.dart';
import '../../../../core/enums/status.dart';
import '../../data/models/auth_input_model.dart';

class AuthState extends Equatable {
  final Status status;
  final String? message;
  final String? nextRoute;
  final bool hidePassword;
  final AuthInputModel? input;

  const AuthState({
    this.status = Status.initial,
    this.message,
    this.nextRoute,
    this.hidePassword = true,
    this.input,
  });

  AuthState copyWith({
    Status? status,
    String? message,
    String? nextRoute,
    bool? hidePassword,
    AuthInputModel? input,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
      nextRoute: nextRoute ?? this.nextRoute,
      hidePassword: hidePassword ?? this.hidePassword,
      input: input ?? this.input,
    );
  }

  @override
  List<Object?> get props => [status, message, nextRoute, hidePassword, input];
}
