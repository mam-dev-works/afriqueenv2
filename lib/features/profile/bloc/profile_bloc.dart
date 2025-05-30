import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:afriqueen/features/profile/bloc/profile_event.dart';
import 'package:afriqueen/features/profile/bloc/profile_state.dart';
import 'package:afriqueen/features/profile/model/profile_model.dart';
import 'package:afriqueen/features/profile/repository/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;
  ProfileBloc({required ProfileRepository repo})
    : _repository = repo,
      super(ProfileInitial()) {


    on<ProfileFetch>((event, emit) async {
      try {
        emit(Loading.fromState(state));
        final ProfileModel? data = await _repository.fetchProfileData();
        if (data != null) return emit(ProfileState(data: data));
      } catch (e) {
        emit(Error.fromState(state, error: e.toString()));
      }
    });
  }
}
