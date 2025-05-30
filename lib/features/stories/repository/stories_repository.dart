import 'package:afriqueen/common/constant/constant_strings.dart';
import 'package:afriqueen/features/stories/model/stories_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class StoriesRepository {
  final FirebaseFirestore firestore;
  final cloudinary = CloudinaryPublic(
    AppStrings.cloudName,
    AppStrings.uploadPreset,
  );

  final ImagePicker _imagePicker = ImagePicker();
  StoriesRepository({FirebaseFirestore? fire})
    : firestore = fire ?? FirebaseFirestore.instance;

  Future<String?> addStoriesImageToCloudinary() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            image.path,
            resourceType: CloudinaryResourceType.Image,
            folder: "afriqueen/stories",
            publicId: "${DateTime.now().millisecond}",
          ),
        );
        return response.secureUrl;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String?> addStoriesVideoToCloudinary() async {
    try {
      final video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: Duration(minutes: 1),
      );
      if (video != null) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            video.path,
            resourceType: CloudinaryResourceType.Video,
            folder: "afriqueen/stories",
            publicId: "${DateTime.now().millisecond}",
          ),
        );
        return response.secureUrl;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<void> uploadStoriesToFirebase(StoriesModel model) async {
    final Map<String, dynamic> data = {
      'id': model.uid,
      'containUrl': model.containUrl,
      'createdDate': model.createdDate,
    };
    await firestore.collection('stories').doc().set(data);
  }


  // Future<StoriesModel>  getStoriesData (){
  //   return 
  // }
}
