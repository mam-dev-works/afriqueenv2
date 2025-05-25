class LoginModel {
  final String email;
  final String password;
  LoginModel({required this.email, required this.password});

  LoginModel copyWith({String? email, String? password}) => LoginModel(
    password: password ?? this.password,
    email: email ?? this.email,
  );
}
// ------------------------model for login--------------------------------