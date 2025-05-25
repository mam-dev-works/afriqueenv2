import 'package:equatable/equatable.dart';

//-------------------------Profile model for user profile ---------------------------------------
class ProfileModel extends Equatable {
  final String pseudo;
  final String sex;
  final int age;
  final String country;
  final String city;
  final List<String> friendship;
  final List<String> passion;
  final List<String> love;
  final List<String> sports;
  final List<String> food;
  final List<String> adventure;
  final DateTime createdDate;
  final String imgURL;
   final String discription;
  const ProfileModel({required     this.discription, 
    required this.pseudo,
    required this.sex,
    required this.age,
    required this.country,
    required this.city,
    required this.friendship,
    required this.passion,
    required this.love,
    required this.sports,
    required this.food,
    required this.adventure,
    required this.imgURL,
    required this.createdDate,
  });

  ProfileModel copyWith({
    String? pseudo,
    String? sex,
    int? age,
    String? country,
    String? city,
    List<String>? friendship,
    List<String>? passion,
    List<String>? love,
    List<String>? sports,
    List<String>? food,
    List<String>? adventure,
    String? imgURL,
     String? discription,
    DateTime? createdDate,
  }) {
    return ProfileModel(
      pseudo: pseudo ?? this.pseudo,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      country: country ?? this.country,
      city: city ?? this.city,
      friendship: friendship ?? this.friendship,
      passion: passion ?? this.passion,
      love: love ?? this.love,
      sports: sports ?? this.sports,
      food: food ?? this.food,
      adventure: adventure ?? this.adventure,
      imgURL: imgURL ?? this.imgURL,
      createdDate: createdDate ?? this.createdDate,
       discription: discription?? this.discription,
    );
  }

  @override
  List<Object?> get props => [
    pseudo,
    sex,
    age,
    country,
    city,
    friendship,
    passion,
    love,
    sports,
    adventure,
    imgURL,
    createdDate,
  ];
}
