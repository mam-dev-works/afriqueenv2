//------------------------------State-------------------------------------
import 'package:equatable/equatable.dart';

class EmailVerificationState extends Equatable {
  final bool isVerified;
  
  const EmailVerificationState({required this.isVerified});

  EmailVerificationState copyWith({bool? isVerified}) =>
      EmailVerificationState(isVerified: isVerified ?? this.isVerified);
  factory EmailVerificationState.initial() =>
      EmailVerificationState(isVerified: false);
  @override
  List<Object> get props => [isVerified];
}

final class EmailVerificationInitial extends EmailVerificationState {
  const EmailVerificationInitial() : super(isVerified: false);
}

final class EmailVerifiedError extends EmailVerificationState {
  final String error;

  EmailVerifiedError.fromState(
    EmailVerificationState state, {
    required this.error,
  }) : super(isVerified: state.isVerified);
  @override
  List<Object> get props => [error];
}

final class AccountDelete extends EmailVerificationState {
  AccountDelete.fromState(EmailVerificationState state)
    : super(isVerified: state.isVerified);
}
