class AuthInputModel {
  final String? userName;
  final String? password;

  AuthInputModel({this.userName, this.password});

  AuthInputModel copyWith({String? userName, String? password}) =>
      AuthInputModel(
        userName: userName ?? this.userName,
        password: password ?? this.password,
      );
}
