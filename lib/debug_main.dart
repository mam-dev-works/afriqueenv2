// run this file to debug a specific page directly:
// flutter run -t lib/debug_main.dart

import 'package:afriqueen/common/constant/constant_colors.dart';
import 'package:afriqueen/common/localization/translations/app_translations.dart';
import 'package:afriqueen/common/theme/app_theme.dart';
import 'package:afriqueen/firebase_options.dart';
import 'package:afriqueen/services/storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:afriqueen/routes/app_routes.dart';
import 'package:afriqueen/routes/app_pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Change this constant to any route from the list below to debug that page
const String DEBUG_ROUTE =
    AppRoutes.main; // ← Change this to debug different pages

/// 📋 AVAILABLE ROUTES (from app_routes.dart):
/// Copy any of these and paste above to debug that page
///
/// Authentication & Onboarding:
/// - AppRoutes.wellcome          // Welcome screen
/// - AppRoutes.signup            // Sign up screen
/// - AppRoutes.login             // Login screen
/// - AppRoutes.forgotPassword    // Forgot password
/// - AppRoutes.emailSent         // Email sent confirmation
/// - AppRoutes.emailVerification // Email verification
/// - AppRoutes.privacyAndPolicy  // Privacy policy
/// - AppRoutes.conditionOfUse    // Terms of use
///
/// Main App:
/// - AppRoutes.main              // Main screen (home with tabs)
/// - AppRoutes.profile           // Profile screen
/// - AppRoutes.profileHome       // Profile home
/// - AppRoutes.setting           // Settings
/// - AppRoutes.editProfile       // Edit profile
///
/// User Management:
/// - AppRoutes.favorite          // Favorites list (⭐ debug favorite button here)
/// - AppRoutes.archive           // Archived users
/// - AppRoutes.blocked           // Blocked users
/// - AppRoutes.chat              // Chat list
///
/// Profile Creation Flow:
/// - AppRoutes.createProfile     // Create profile flow
/// - AppRoutes.name              // Name screen
/// - AppRoutes.gender            // Gender screen
/// - AppRoutes.age               // Age screen
/// - AppRoutes.address           // Address screen
/// - AppRoutes.interests         // Interests screen
/// - AppRoutes.passion           // Passion screen
/// - AppRoutes.upload            // Upload images
/// - AppRoutes.description       // Description
///
/// Stories:
/// - AppRoutes.myStory           // My stories
/// - AppRoutes.createStory       // Create story
///
/// Settings & Features:
/// - AppRoutes.languageSelection         // Language selection
/// - AppRoutes.referral                  // Referral program
/// - AppRoutes.premiumPlans              // Premium plans
/// - AppRoutes.contactUs                 // Contact us
/// - AppRoutes.identityVerification      // Identity verification
/// - AppRoutes.notificationSettings      // Notification settings
/// - AppRoutes.suspendAccount            // Suspend account
/// - AppRoutes.deleteAccount             // Delete account
/// - AppRoutes.comprehensiveEditProfile  // Comprehensive edit profile
/// - AppRoutes.sendGifts                 // Send gifts
/// - AppRoutes.invisibleMode             // Invisible mode
// ============================================

/// DEBUG MODE MAIN FILE
///
/// TO USE:
/// 1. Change DEBUG_ROUTE constant above to the page you want to debug
/// 2. Update test credentials in _signInTestUser() if needed
/// 3. Run: flutter run -t lib/debug_main.dart
/// 4. The app will open directly to your chosen page!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init();

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

  // IMPORTANT: Sign in with test credentials for main screen
  await _signInTestUser();

  runApp(DebugApp());
}

/// IMPORTANT: Sign in with test credentials
/// Replace with YOUR test account email/password
Future<void> _signInTestUser() async {
  try {
    // TODO: Replace with your actual test email/password
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'jeevankoirima@gmail.com', // ← CHANGE THIS
      password: 'Password123', // ← CHANGE THIS TO YOUR ACTUAL PASSWORD
    );
    debugPrint('✅ Signed in as test user for debugging');
  } catch (e) {
    debugPrint('⚠️ Could not sign in test user: $e');
    debugPrint(
        '⚠️ Please update the credentials in debug_main.dart _signInTestUser()');
  }
}

class DebugApp extends StatelessWidget {
  final AppGetStorage _appGetStorage = AppGetStorage();

  DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => getx.GetMaterialApp(
        title: 'Afriqueen DEBUG',
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: Locale(_appGetStorage.getLanguageCode()),
        theme: lightTheme,
        onGenerateRoute: onGenerateRoute, // Add route generator
        home: _buildDebugScreen(),
      ),
    );
  }

  /// Builds the debug screen based on DEBUG_ROUTE constant
  /// This automatically uses the route configuration from app_pages.dart
  Widget _buildDebugScreen() {
    debugPrint('🐛 DEBUG MODE: Loading route -> $DEBUG_ROUTE');

    // Generate the route using the app's routing system
    final route = onGenerateRoute(RouteSettings(name: DEBUG_ROUTE));

    if (route == null) {
      // Fallback if route is not found
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 20),
                Text(
                  '❌ Route not found!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'DEBUG_ROUTE: $DEBUG_ROUTE',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Check the DEBUG_ROUTE constant in debug_main.dart\nand make sure it matches a valid route from AppRoutes.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Return a Builder to navigate to the route
    return Builder(
      builder: (context) {
        // Navigate to the route after the frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).push(route);
        });
        // Show a loading indicator while navigating
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
