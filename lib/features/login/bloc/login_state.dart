import 'package:equatable/equatable.dart';
// State for login Screen---------------------------

class LoginState extends Equatable {
  final bool isLoginPasswordVisible;

  const LoginState({required this.isLoginPasswordVisible});
  factory LoginState.initial() {
    return const LoginState(isLoginPasswordVisible: true);
  }
  LoginState copyWith({bool? isLoginPasswordVisible}) => LoginState(
    isLoginPasswordVisible:
        isLoginPasswordVisible ?? this.isLoginPasswordVisible,
  );
  @override
  List<Object> get props => [isLoginPasswordVisible];
}

final class LoginInitial extends LoginState {
  const LoginInitial() : super(isLoginPasswordVisible: true);
  @override
  List<Object> get props => [isLoginPasswordVisible];
}

final class LoginSuccess extends LoginState {
  LoginSuccess.fromState(LoginState state)
    : super(isLoginPasswordVisible: state.isLoginPasswordVisible);
  @override
  List<Object> get props => [isLoginPasswordVisible];
}

final class LoginLoading extends LoginState {
  LoginLoading.fromState(LoginState state)
    : super(isLoginPasswordVisible: state.isLoginPasswordVisible);
  @override
  List<Object> get props => [isLoginPasswordVisible];
}

final class LoginError extends LoginState {
  final String error;
  LoginError.fromState(LoginState state, {required this.error})
    : super(isLoginPasswordVisible: state.isLoginPasswordVisible);
  @override
  List<Object> get props => [isLoginPasswordVisible];
}

final class GoogleLoginError extends LoginState {
  final String error;
  GoogleLoginError.fromState(LoginState state, {required this.error})
    : super(isLoginPasswordVisible: state.isLoginPasswordVisible);
  @override
  List<Object> get props => [isLoginPasswordVisible];
}

final class GoogleLoginNewUser extends LoginState {
  GoogleLoginNewUser.fromState(LoginState state)
    : super(isLoginPasswordVisible: state.isLoginPasswordVisible);
  @override
  List<Object> get props => [isLoginPasswordVisible];
}

final class GoogleLoginOldUser extends LoginState {
  GoogleLoginOldUser.fromState(LoginState state)
    : super(isLoginPasswordVisible: state.isLoginPasswordVisible);
  @override
  List<Object> get props => [isLoginPasswordVisible];
}
