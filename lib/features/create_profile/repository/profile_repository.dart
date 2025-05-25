import 'package:afriqueen/features/create_profile/model/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

//--------------------Profile repository ---------------------------------------------
class ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;
  Future<void> uploadToFirebase(ProfileModel profile) async {
    final box = GetStorage();

    try {
      final Map<String, dynamic> userData = {
        'id': FirebaseAuth.instance.currentUser!.uid,
        'pseudo': box.read('pseudo') ?? profile.pseudo,
        ' sex': box.read('sex') ?? profile.sex,
        'age': box.read('age') ?? profile.age,
        'country': box.read('country') ?? profile.country,
        'city': box.read('city') ?? profile.city,
        'friendship': box.read('friendship') ?? profile.friendship,
        'passion': box.read('passion') ?? profile.passion,
        'createdDate': DateTime.now(),
        'love': box.read('love') ?? profile.love,
        'sports': box.read('sports') ?? profile.sports,
        'food': box.read('food') ?? profile.food,
        'adventure': box.read('adventure') ?? profile.adventure,
        'imgURL': box.read('imgURL') ?? profile.imgURL,
        'discription': box.read('discription') ?? profile.discription,
      };

      await _firestore.collection('profile').doc().set(userData);
    } catch (e) {
      debugPrint(
        "Error while uploading profile data to firebase : ${e.toString()}",
      );

      rethrow;
    }
  }

  Future<String?> imagePicker() async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (img != null) return img.path;
    } catch (e) {
      debugPrint("Error while picking imaage : : ${e.toString()}");
      rethrow;
    }

    return null;
  }

  Future<String?> uploadToCloudinary(String imagePath) async {
    try {
      final cloudinary = CloudinaryPublic("dwzriczge", "afrikhc9o0");
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imagePath,
          resourceType: CloudinaryResourceType.Image,
          folder: "afriqueen/images",
          publicId: "${DateTime.now().millisecond}",
        ),
      );

      return response.secureUrl;
    } catch (e) {
      rethrow;
    }
  }
}
