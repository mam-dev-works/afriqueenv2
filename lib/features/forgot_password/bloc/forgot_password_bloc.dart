import 'package:afriqueen/features/forgot_password/bloc/forgot_password_event.dart';
import 'package:afriqueen/features/forgot_password/bloc/forgot_password_state.dart';
import 'package:afriqueen/features/forgot_password/models/forgot_password_models.dart';
import 'package:afriqueen/features/forgot_password/repository/forgot_password_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//----------------------Bloc for forgot password screen-----------------------------------
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository repository;
  ForgotPasswordModel model = ForgotPasswordModel(email: "");
  ForgotPasswordBloc({required ForgotPasswordRepository repo})
    : repository = repo,
      super(ForgotPasswordInitial()) {
    //-------------------------User email ------------------------
    on<UserEmail>((event, emit) {
      model = model.copyWith(email: event.userEmail);
    });
    // --------------------------Button clicked than this run----------------------------
    on<SendButtonClicked>((event, emit) async {
      try {
        await repository.sendEmailToRestPassword(model);
      } catch (e) {
        debugPrint("Error in Sending email to reset password ${e.toString()}");
      }
    });
  }
}
