import 'package:equatable/equatable.dart';

//----------------Create Profile State----------------------
class CreateProfileState extends Equatable {
  final String gender;
  final DateTime dob;
  final List<String> friendship;
  final List<String> passion;
  final List<String> love;
  final List<String> sports;
  final List<String> food;
  final List<String> adventure;
  final String imgURL;
  final String discription;
  const CreateProfileState({
    required this.love,
    required this.sports,
    required this.food,
    required this.adventure,
    required this.imgURL,
    required this.gender,
    required this.dob,
    required this.friendship,
    required this.passion,
    required this.discription,
  });

  factory CreateProfileState.initial() {
    return CreateProfileState(
      gender: 'Male',
      dob: DateTime.now(),
      friendship: [],
      passion: [],
      love: [],
      sports: [],
      food: [],
      adventure: [],
      imgURL: '',
      discription: '',
    );
  }
  CreateProfileState copyWith({
    String? gender,
    DateTime? dob,
    List<String>? friendship,
    List<String>? passion,
    List<String>? love,
    List<String>? sports,
    List<String>? food,
    List<String>? adventure,
    String? imgURL,
    String? discription,
  }) => CreateProfileState(
    gender: gender ?? this.gender,
    dob: dob ?? this.dob,
    friendship: friendship ?? this.friendship,
    passion: passion ?? this.passion,
    love: love ?? this.love,
    sports: sports ?? this.sports,
    food: food ?? this.food,
    adventure: adventure ?? this.adventure,
    imgURL: imgURL ?? this.imgURL,
    discription: discription ?? this.discription,
  );
  @override
  List<Object> get props => [
    gender,
    friendship,
    dob,
    passion,
    love,
    sports,
    food,
    adventure,
    imgURL,
    discription,
  ];
}

final class CreateProfileInitial extends CreateProfileState {
  CreateProfileInitial()
    : super(
        gender: 'Male',
        dob: DateTime.now(),
        friendship: [],
        passion: [],
        love: [],
        sports: [],
        food: [],
        imgURL: '',
        adventure: [],
        discription: '',
      );
}

final class Loading extends CreateProfileState {
  Loading.fromState(CreateProfileState state)
    : super(
        gender: state.gender,
        dob: state.dob,
        friendship: state.friendship,
        passion: state.passion,
        love: state.love,
        sports: state.sports,
        food: state.food,
        imgURL: state.imgURL,
        adventure: state.adventure,
        discription: '',
      );
}

final class Success extends CreateProfileState {
  Success.fromState(CreateProfileState state)
    : super(
        gender: state.gender,
        dob: state.dob,
        friendship: state.friendship,
        passion: state.passion,
        love: state.love,
        sports: state.sports,
        food: state.food,
        imgURL: state.imgURL,
        adventure: state.adventure,
        discription: state.discription,
      );
}

final class Error extends CreateProfileState {
  final String errorMessage;

  Error.fromState(CreateProfileState state, {required this.errorMessage})
    : super(
        gender: state.gender,
        dob: state.dob,
        friendship: state.friendship,
        passion: state.passion,
        love: state.love,
        sports: state.sports,
        food: state.food,
        imgURL: state.imgURL,
        adventure: state.adventure,
        discription: state.discription,
      );

  @override
  List<Object> get props => [errorMessage];
}
