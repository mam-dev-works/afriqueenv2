import 'package:equatable/equatable.dart';
//------------------------------------------------ State------------------------------------
class WellcomeState extends Equatable {
  final String? languageCode;
  const WellcomeState({this.languageCode});

  factory WellcomeState.initil() {
    return WellcomeState(languageCode: 'en');
  }

  WellcomeState copyWith({String? languageCode}) {
    return WellcomeState(languageCode: languageCode ?? this.languageCode);
  }

  @override
  List<Object?> get props => [languageCode];
}

class WellcomeInitial extends WellcomeState {}
