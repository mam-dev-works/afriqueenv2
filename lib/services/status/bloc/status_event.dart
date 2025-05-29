import 'package:equatable/equatable.dart';

sealed class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object> get props => [];
}

final class GetStatus extends StatusEvent {
final String uid;
const GetStatus({required this.uid});

}
