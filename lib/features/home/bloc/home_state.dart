import 'package:afriqueen/features/home/model/home_model.dart';

import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final List<HomeModel?> data;
  const HomeState({required this.data});

  HomeState copyWith({List<HomeModel?>? data}) =>
      HomeState(data: data ?? this.data);

  factory HomeState.initial() {
    return HomeState(data: []);
  }
  @override
  List<Object> get props => [data];
}

final class HomeInitial extends HomeState {
  HomeInitial() : super(data: []);
}

final class Loading extends HomeState {
  Loading.fromState(HomeState state) : super(data: state.data);
}

final class Error extends HomeState {
  final String error;
  Error.fromState(HomeState state, {required this.error})
    : super(data: state.data);
  @override
  List<Object> get props => [error];
}
