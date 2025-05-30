// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StoriesModel extends Equatable {
  final String uid;
  final String containUrl;
  final DateTime createdDate;
  const StoriesModel({
    required this.uid,
    required this.containUrl,
    required this.createdDate,
  });
  // StoriesModel({required this.uid, required this.containUrl, required this.createdDate});

  // StoriesModel copyWith({String? uid, String? containUrl , DateTime? createdDate}) {
  //   return StoriesModel(
  //     uid: uid ?? this.uid,
  //     containUrl: containUrl ?? this.containUrl,
  //     createdDate: createdDate ?? this.createdDate
  //   );
  // }

  // @override
  // List<Object?> get props => [uid, containUrl,createdDate];

  static StoriesModel empty = StoriesModel(
    uid: '',
    containUrl: '',
    createdDate: DateTime(0),
  );

  StoriesModel copyWith({
    String? uid,
    String? containUrl,
    DateTime? createdDate,
  }) {
    return StoriesModel(
      uid: uid ?? this.uid,
      containUrl: containUrl ?? this.containUrl,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'containUrl': containUrl,
      'createdDate': createdDate.millisecondsSinceEpoch,
    };
  }

  factory StoriesModel.fromMap(Map<String, dynamic> map) {
    return StoriesModel(
      uid: map['uid'] as String,
      containUrl: map['containUrl'] as String,
  createdDate:
          (map['createdDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoriesModel.fromJson(String source) =>
      StoriesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [uid, containUrl, createdDate];
}
