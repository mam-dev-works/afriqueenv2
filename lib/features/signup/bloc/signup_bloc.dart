import 'package:afriqueen/features/signup/bloc/signup_event.dart';
import 'package:afriqueen/features/signup/bloc/signup_state.dart';
import 'package:afriqueen/features/signup/models/signup_model.dart';
import 'package:afriqueen/features/signup/repository/signup_repository.dart';
import 'package:afriqueen/services/storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepository _repository;
  bool isBoxChecked = false;
  bool isPasswordHidden = true;
  final AppGetStorage appGetStorage = AppGetStorage();
  SignUpModel signUpModel = SignUpModel(email: '', password: '');

  SignupBloc({required SignupRepository signupRepository})
    : _repository = signupRepository,
      super(SignupInitial()) {
    on<EmailChanged>(onEmailChanged);
    on<PasswordChanged>(onPasswordChanged);
    on<Submit>(_onSubmit);
    on<PasswordVisibility>(_onPasswordVisibility);
    on<CheckedBox>(_onCheckedBox);
  }
  //------------------------- on Clicking Signup button it  will run-----------------------------
  Future<void> _onSubmit(Submit event, Emitter<SignupState> emit) async {
    emit(Loading.fromState(state));
    UserCredential? userCredential = await _repository.signupWithEmail(
      signUpModel,
    );

    if (userCredential != null) {
      appGetStorage.setPageNumber(1);
      emit(Success.fromState(state));
    } else {
      debugPrint("Error : ${_repository.errorMessge.toString()}");
      emit(SignUpfail.fromState(state, error: _repository.errorMessge!.tr));
    }
  }

  //------------------------User input for email-------------------------------
  void onEmailChanged(EmailChanged event, Emitter<SignupState> emit) {
    signUpModel = signUpModel.copyWith(email: event.email);
  }

  // ---------------------------- password from user---------------------
  void onPasswordChanged(PasswordChanged event, Emitter<SignupState> emit) {
    signUpModel = signUpModel.copyWith(password: event.password);
  }

  //-----------------------Toggle to show passsword-------------------------
  void _onPasswordVisibility(
    PasswordVisibility event,
    Emitter<SignupState> emit,
  ) {
    isPasswordHidden = !isPasswordHidden;
    emit(state.copyWith(isPasswordHidden: isPasswordHidden));
  }

  //-------------------------------------- privacy and policy checked box----------------------------------
  void _onCheckedBox(CheckedBox event, Emitter<SignupState> emit) {
    isBoxChecked = !isBoxChecked;
    emit(state.copyWith(isChecked: isBoxChecked));
  }
}
