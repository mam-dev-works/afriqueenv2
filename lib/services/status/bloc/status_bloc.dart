import 'package:afriqueen/services/status/bloc/status_event.dart';
import 'package:afriqueen/services/status/bloc/status_state.dart';
import 'package:afriqueen/services/status/model/status_model.dart';
import 'package:afriqueen/services/status/repository/status_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final StatusRepository _repository;
  StatusBloc({required StatusRepository statusrepository})
    : _repository = statusrepository,
      super(StatusInitial()) {
    on<GetStatus>((GetStatus event, Emitter<StatusState> emit) async {
      final user = await FirebaseAuth.instance.authStateChanges().first;

      if (user != null) {
        final StatusModel? data = await _repository.getUserPreence(event.uid);
        if (data != null && !emit.isDone) {
          emit(state.copyWith(status: data));
        }
      }
    });
  }
}
