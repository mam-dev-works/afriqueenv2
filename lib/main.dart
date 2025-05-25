import 'package:afriqueen/app.dart';
import 'package:afriqueen/common/constant/constant_colors.dart';
import 'package:afriqueen/features/create_profile/bloc/create_profile_bloc.dart';
import 'package:afriqueen/features/create_profile/repository/profile_repository.dart';
import 'package:afriqueen/features/email_verification/bloc/email_verification_bloc.dart';
import 'package:afriqueen/features/email_verification/repository/email_verification_repository.dart';
import 'package:afriqueen/features/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:afriqueen/features/forgot_password/repository/forgot_password_repository.dart';
import 'package:afriqueen/features/login/bloc/login_bloc.dart';
import 'package:afriqueen/features/login/repository/login_repository.dart';
import 'package:afriqueen/features/signup/bloc/signup_bloc.dart';
import 'package:afriqueen/features/signup/repository/signup_repository.dart';
import 'package:afriqueen/features/wellcome/bloc/wellcome_bloc.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
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
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
    // .env
  );

  // Get stroage
  await GetStorage.init();
  // Initialize HydratedStorage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
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
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (context) => EmailVerificationRepository()),
      RepositoryProvider(create: (context) => LoginRepository()),
      RepositoryProvider(create: (context) => ForgotPasswordRepository()),
      RepositoryProvider(create: (context) => SignupRepository()),
      RepositoryProvider(create: (context) => ProfileRepository()),
    ],
    child: _multiBlocProvider(),
  );
}

//-----------------------Bloc Provider--------------------------------
MultiBlocProvider _multiBlocProvider() {
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create:
            (context) =>
                LoginBloc(loginrepository: context.read<LoginRepository>()),
      ),
      BlocProvider(
        create:
            (context) =>
                SignupBloc(signupRepository: context.read<SignupRepository>()),
      ),

      BlocProvider(
        create:
            (context) => ForgotPasswordBloc(
              repo: context.read<ForgotPasswordRepository>(),
            ),
      ),

      BlocProvider(
        create:
            (context) => EmailVerificationBloc(
              repository: context.read<EmailVerificationRepository>(),
            ),
      ),
      BlocProvider(
        create:
            (context) => CreateProfileBloc(
              repository: context.read<ProfileRepository>(),
            ),
      ),
      BlocProvider(create: (context) => WellcomeBloc()),
    ],
    child: const MyApp(),
  );
}
