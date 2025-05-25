
import 'package:equatable/equatable.dart';
//-----------model for signup-------------------
class SignUpModel extends Equatable {
  final String email;
  final String password;

  const SignUpModel({required this.email, required this.password});

  SignUpModel copyWith({String? email, String? password}) => SignUpModel(
    email: email ?? this.email,
    password: password ?? this.password,
  );

  @override
  List<Object?> get props => [email, password];
}


