//-------------------event for login page ------------------------------

import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginEmailChanged extends LoginEvent {
  final String email;
  const LoginEmailChanged({required this.email});
    @override
  List<Object> get props => [email];
}

final class LoginSubmit extends LoginEvent {}


final class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged({required this.password});
    @override
  List<Object> get props => [password];
}

final class LoginPasswordVisibility extends LoginEvent {}

final class GoogleSignInButtonClicked extends LoginEvent {}