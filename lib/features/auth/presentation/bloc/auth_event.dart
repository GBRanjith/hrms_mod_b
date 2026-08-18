import '../../data/models/auth_input_model.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

enum LoginField { userName, password }

class LoginOnFieldChanged extends AuthEvent {
  final LoginField field;
  final String value;

  LoginOnFieldChanged({required this.field, required this.value});
}

class LoginSubmitted extends AuthEvent {
  final AuthInputModel loginInputModel;
  LoginSubmitted(this.loginInputModel);
}

class LoginOnChangeHidePassword extends AuthEvent {
  final bool hidePassword;
  LoginOnChangeHidePassword(this.hidePassword);
}
