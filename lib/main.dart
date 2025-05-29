import 'package:afriqueen/app.dart';
import 'package:afriqueen/common/constant/constant_colors.dart';
import 'package:afriqueen/features/create_profile/bloc/create_profile_bloc.dart';
import 'package:afriqueen/features/create_profile/repository/create_profile_repository.dart';
import 'package:afriqueen/features/email_verification/bloc/email_verification_bloc.dart';
import 'package:afriqueen/features/email_verification/repository/email_verification_repository.dart';
import 'package:afriqueen/features/email_verification/screen/email_verification_screen.dart';
import 'package:afriqueen/features/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:afriqueen/features/forgot_password/repository/forgot_password_repository.dart';
import 'package:afriqueen/features/forgot_password/screen/forgot_password_screen.dart';
import 'package:afriqueen/features/home/bloc/home_bloc.dart';
import 'package:afriqueen/features/home/screen/home_screen.dart';
import 'package:afriqueen/features/login/bloc/login_bloc.dart';
import 'package:afriqueen/features/login/repository/login_repository.dart';
import 'package:afriqueen/features/login/screen/login_screen.dart';
import 'package:afriqueen/features/main/repository/home_repository.dart';
import 'package:afriqueen/features/profile/bloc/profile_bloc.dart';
import 'package:afriqueen/features/profile/repository/profile_repository.dart';
import 'package:afriqueen/features/profile/screen/profile_screen.dart';
import 'package:afriqueen/features/signup/bloc/signup_bloc.dart';
import 'package:afriqueen/features/signup/repository/signup_repository.dart';
import 'package:afriqueen/features/signup/screen/signup_screen.dart';
import 'package:afriqueen/features/wellcome/bloc/wellcome_bloc.dart';
import 'package:afriqueen/features/wellcome/screen/wellcome_screen.dart';
import 'package:afriqueen/services/status/bloc/status_bloc.dart';
import 'package:afriqueen/services/status/repository/status_repository.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
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
  //---------------Note: Firebase doesnot have  close function don't need to dispose-----------------------------------
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider(lazy: true, create: (context) => StatusRepository()),
      RepositoryProvider(lazy: true, create: (context) => HomeRepository()),
      RepositoryProvider(lazy: true, create: (context) => ProfileRepository()),
      RepositoryProvider(
        lazy: true,
        create: (context) => EmailVerificationRepository(),
      ),
      RepositoryProvider(lazy: true, create: (context) => LoginRepository()),
      RepositoryProvider(
        lazy: true,
        create: (context) => ForgotPasswordRepository(),
      ),
      RepositoryProvider(lazy: true, create: (context) => SignupRepository()),
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
        create: (context) => HomeBloc(repo: context.read<HomeRepository>()),
        child: HomeScreen(),
      ),
      BlocProvider(
        child: ProfileScreen(),
        create:
            (context) => ProfileBloc(repo: context.read<ProfileRepository>()),
      ),
      BlocProvider(
        child: LoginScreen(),
        create:
            (context) =>
                LoginBloc(loginrepository: context.read<LoginRepository>()),
      ),
      BlocProvider(
        child: SignupScreen(),
        create:
            (context) =>
                SignupBloc(signupRepository: context.read<SignupRepository>()),
      ),

      BlocProvider(
        child: ForgotPasswordScreen(),
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
        child: EmailVerificationScreen(),
      ),
      BlocProvider(
        create:
            (context) => CreateProfileBloc(
              repository: context.read<CreateProfileRepository>(),
            ),
      ),
      BlocProvider(
        child: WellcomeScreen(),
        create: (context) => WellcomeBloc(),
      ),

      BlocProvider(
        create:
            (context) =>
                StatusBloc(statusrepository: context.read<StatusRepository>()),
      ),
    ],
    child: const MyApp(),
  );
}
