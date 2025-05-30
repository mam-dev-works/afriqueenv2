import 'package:equatable/equatable.dart';

import 'package:afriqueen/features/stories/model/stories_model.dart';

class StoriesState extends Equatable {
  final StoriesModel data;
  const StoriesState({required this.data});

  @override
  List<Object> get props => [data];
}

final class StoriesInitial extends StoriesState {
  StoriesInitial() : super(data: StoriesModel.empty);
}

final class StoriesLoading extends StoriesState {
  StoriesLoading.fromState(StoriesState state) : super(data: state.data);
}

final class StoriesSuccess extends StoriesState {
  StoriesSuccess.fromState(StoriesState state) : super(data: state.data);
}

final class StoriesError extends StoriesState {
  final String errorMessage;
  StoriesError.fromState(StoriesState state, {required this.errorMessage})
    : super(data: state.data);
}
