import 'package:afriqueen/app.dart';
import 'package:afriqueen/common/constant/constant_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:afriqueen/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:afriqueen/features/gifts/service/gift_recharge_service.dart';
import 'package:bloc/bloc.dart';
import 'package:afriqueen/core/bloc/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
    debugPrint(
        'Project ID: ${DefaultFirebaseOptions.currentPlatform.projectId}');
    debugPrint('App ID: ${DefaultFirebaseOptions.currentPlatform.appId}');
  } catch (e, stackTrace) {
    debugPrint('Firebase initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
  }

  // Get stroage
  await GetStorage.init();

  // Set global BLoC observer for debugging events, state changes and errors
  Bloc.observer = AppBlocObserver();

  // Initialize HydratedStorage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.floralWhite,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Start the gift recharge service
  GiftRechargeService.startPeriodicRechargeCheck();

  runApp(MyApp());
}
