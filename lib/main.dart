import 'package:afriqueen/app.dart';
import 'package:afriqueen/common/constant/constant_colors.dart';
import 'package:afriqueen/features/create_profile/bloc/create_profile_bloc.dart';
import 'package:afriqueen/features/create_profile/repository/create_profile_repository.dart';
import 'package:afriqueen/features/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:afriqueen/features/forgot_password/repository/forgot_password_repository.dart';
import 'package:afriqueen/features/forgot_password/screen/forgot_password_screen.dart';
import 'package:afriqueen/services/status/bloc/status_bloc.dart';
import 'package:afriqueen/services/status/repository/status_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afriqueen/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Get stroage
  await GetStorage.init();
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

  runApp(_multiRepositoryProvider());
}

//--------------------Bloc Repository---------------------------------
MultiRepositoryProvider _multiRepositoryProvider() {
  //---------------Note: Firebase doesnot have  close function don't need to dispose-----------------------------------
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider(lazy: true, create: (context) => StatusRepository()),

      RepositoryProvider(
        lazy: true,
        create: (context) => ForgotPasswordRepository(),
      ),

      RepositoryProvider(
        lazy: true,

        create: (context) => CreateProfileRepository(),
      ),
    ],
    child: _multiBlocProvider(),
  );
}

//-----------------------Bloc Provider--------------------------------
MultiBlocProvider _multiBlocProvider() {
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        child: ForgotPasswordScreen(),
        create: (context) =>
            ForgotPasswordBloc(repo: context.read<ForgotPasswordRepository>()),
      ),

      BlocProvider(
        create: (context) => CreateProfileBloc(
          repository: context.read<CreateProfileRepository>(),
        ),
      ),

      BlocProvider(
        create: (context) =>
            StatusBloc(statusrepository: context.read<StatusRepository>()),
      ),
    ],
    child: const MyApp(),
  );
}
