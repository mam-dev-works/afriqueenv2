import 'package:afriqueen/features/home/bloc/home_event.dart';
import 'package:afriqueen/features/home/bloc/home_state.dart';
import 'package:afriqueen/features/home/model/home_model.dart';
import 'package:afriqueen/features/main/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository __repository;
  HomeBloc({required HomeRepository repo})
    : __repository = repo,
      super(HomeInitial()) {
    on<FetchAllExceptCurrentUser>((event, emit) async {
      try {
        emit(Loading.fromState(state));
        final List<HomeModel?> data =
            await __repository.fetchAllExceptCurrentUser();
        return emit(HomeState(data: data));
      } catch (e) {
        emit(Error.fromState(state, error: e.toString()));
      
      }
    });
  }
}
