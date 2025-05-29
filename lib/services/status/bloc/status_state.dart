import 'package:afriqueen/services/status/model/status_model.dart';
import 'package:equatable/equatable.dart';

class StatusState extends Equatable {
  final StatusModel status;
  const StatusState({required this.status});

  StatusState copyWith({StatusModel? status}) =>
      StatusState(status: status ?? this.status);

  factory StatusState.initial() {
    return StatusState(status:StatusModel.empty);
  }
  @override
  List<Object> get props => [status];
}

final class StatusInitial extends StatusState {
   StatusInitial() : super(status:StatusModel.empty);
}
