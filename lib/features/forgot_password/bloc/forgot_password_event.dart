

import 'package:equatable/equatable.dart';
//-----------------------------------Event-------------------------------
sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}



final class UserEmail extends ForgotPasswordEvent {
  final String userEmail;
  const UserEmail({required this.userEmail});
}
final class SendButtonClicked extends ForgotPasswordEvent {}
