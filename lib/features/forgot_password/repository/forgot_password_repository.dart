import 'package:afriqueen/features/forgot_password/models/forgot_password_models.dart';
import 'package:afriqueen/services/storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

//--------------------------- Repository for FP screen------------------------------
class ForgotPasswordRepository {
  final FirebaseAuth auth;
  final AppGetStorage appGetStorage = AppGetStorage();

  ForgotPasswordRepository({FirebaseAuth? firebaseAuth})
    : auth = firebaseAuth ?? FirebaseAuth.instance;

  Future sendEmailToRestPassword(ForgotPasswordModel model) async {
    try {
      await auth.setLanguageCode(appGetStorage.getLanguageCode());
      await auth.sendPasswordResetEmail(email: model.email);
    } catch (e) {
      rethrow;
    }
  }
}
