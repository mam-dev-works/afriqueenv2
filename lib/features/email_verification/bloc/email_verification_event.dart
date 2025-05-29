import 'package:equatable/equatable.dart';
//----------------------------Event--------------------------------
sealed class EmailVerificationEvent extends Equatable {
  const EmailVerificationEvent();

  @override
  List<Object> get props => [];
}

final class OnButtonClicked extends EmailVerificationEvent {}

final class OnClickedDeleteButton extends EmailVerificationEvent {}


final class ResetEmailVerification extends EmailVerificationEvent {}