# AfriQueen - AI Coding Agent Instructions

## Project Identity & Architecture

**AfriQueen** is a Flutter dating/social networking app with Firebase backend. This is a **legacy "vibe coded" project** with technical debt, inconsistent patterns, and mixed state management approaches. Accept this reality and work incrementally.

### Critical Context
- **State Management**: BLoC (primary) + GetX (navigation only) + setState (too much, reduce it)
- **Navigation**: GetX navigation (`Get.toNamed()`, not GoRouter)
- **Firebase**: Auth + Firestore + Realtime Database + Storage + Dynamic Links
- **Persistence**: HydratedBloc for state, GetStorage for preferences
- **Real-time Features**: Chat, user presence, stories, matching

## Core Architecture Patterns

### 1. Feature-First Structure
```
lib/
├── features/{feature}/          # Each feature is self-contained
│   ├── bloc/                    # State management
│   ├── repository/              # Data layer (Firebase calls)
│   ├── model/                   # Data models (Equatable)
│   ├── screen/ or view/         # UI screens
│   └── widgets/                 # Feature-specific widgets
├── common/                      # Shared UI components
├── core/                        # Cross-cutting concerns (connectivity)
├── services/                    # Shared services (location, permissions, storage)
└── routes/                      # Navigation setup
```

### 2. State Management Rules (from about_this_project.md)
- **New features**: ALWAYS use BLoC pattern
- **BLoC usage**: 76 files, 18 bloc files - this is the standard
- **GetX**: ONLY for navigation (`Get.toNamed()`), NEVER for state
- **setState**: 262 instances - avoid adding more, refactor when touching code
- **If feature uses BLoC**: Never add setState to it

### 3. BLoC Pattern (Standard Implementation)
```dart
// Event (sealed class with Equatable)
sealed class FeatureEvent extends Equatable {
  const FeatureEvent();
}

// State (class extending Equatable)  
class FeatureState extends Equatable {
  final bool isLoading;
  final String? error;
  // ...
}

// Bloc
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final FeatureRepository repository;
  
  FeatureBloc({required this.repository}) : super(FeatureInitial()) {
    on<EventName>(_onEventName);
  }
  
  Future<void> _onEventName(EventName event, Emitter<FeatureState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await repository.fetchData();
      emit(state.copyWith(data: result, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
```

### 4. Repository Pattern (Firebase Access)
```dart
class FeatureRepository {
  final FirebaseFirestore firebaseFirestore;
  
  // Constructor injection for testability
  FeatureRepository({FirebaseFirestore? firestore})
      : firebaseFirestore = firestore ?? FirebaseFirestore.instance;
      
  Future<List<Model>> fetchData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await firebaseFirestore
        .collection('user')
        .where('id', isEqualTo: uid)
        .get();
    return snapshot.docs.map((doc) => Model.fromMap(doc.data())).toList();
  }
}
```

**Critical Firestore Pattern**: The app uses `id` field (string) in documents to store UIDs, NOT the document ID. Always query: `.where('id', isEqualTo: uid)` not `.doc(uid)`.

### 5. Navigation (GetX)
```dart
// In app.dart - route registration
onGenerateRoute: onGenerateRoute,

// Routes defined in lib/routes/app_routes.dart
class AppRoutes {
  static const login = '/login';
  static const main = '/main';
  // ...
}

// Navigation calls
Get.toNamed(AppRoutes.profile);
Get.offAllNamed(AppRoutes.login); // Clear stack
```

### 6. App Initialization (main.dart)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  HydratedBloc.storage = await HydratedStorage.build(...);
  GiftRechargeService.startPeriodicRechargeCheck();
  runApp(MyApp());
}
```

### 7. Connectivity Monitoring (lib/core/connectivity/)
- **BLoC-based**: ConnectivityBloc monitors network in real-time
- **UI**: NoInternetBanner widget shows at top when offline
- **Helper**: `ConnectivityHelper.isOnline()` for manual checks
- **Integration**: Provided at app root in `app.dart`, listen in features with `context.read<ConnectivityBloc>()`

## Development Workflow

### Running the App
```bash
flutter run                    # Default device
flutter run -d chrome          # Web
flutter run -d linux           # Linux desktop
```

**Common Issue**: If `flutter run` exits with code 1, check:
1. Device is connected/emulator running
2. Firebase configuration correct (google-services.json)
3. All dependencies installed (`flutter pub get`)

### Testing
```bash
flutter test                           # Run all tests
flutter test --coverage                # With coverage
bash run_tests.sh                      # Project script
```

**Current State**: Minimal test coverage. When adding features, write tests for new code only. See TESTING_GUIDE.md for patterns.

### Code Quality
```bash
dart format lib/                       # Format code
flutter analyze                        # Lint checks
```

Uses `bloc_lint` for BLoC-specific linting (analysis_options.yaml).

## Critical Services & Utilities

### Services (lib/services/)
- **PremiumService**: Check user premium status
- **InvisibleModeService**: Hide user from discovery (premium feature)
- **StatusBloc**: User online/offline status (BLoC pattern)
- **LocationService** (location/): GPS + geocoding
- **AppPermission** (permissions/): Permission handling
- **LogoutService**: Centralized logout logic
- **AppGetStorage** (storage/): GetStorage wrapper for preferences

### Common Widgets (lib/common/widgets/)
- **CommonButton**: Standard button component
- **CommonTextField**: Text input with validation
- **CustomCircularIndicator**: Loading spinner
- **PremiumInfoDialog**: Premium feature prompts
- **UserStatus**: Online/offline indicator

### Constants
- **AppColors** (common/constant/constant_colors.dart): Color palette
- **AppStrings** (common/constant/constant_strings.dart): Text constants

## Firebase Integration

### Collections Used
- `user`: User profiles (query by `id` field, not document ID)
- `chat`: Chat messages
- `stories`: User stories
- `events`: Event messages
- Firebase Realtime Database for presence/status

### Authentication
```dart
FirebaseAuth.instance.currentUser!.uid  // Current user ID
FirebaseAuth.instance.authStateChanges() // Auth stream
```

### Dynamic Links & Deep Links
- Firebase Dynamic Links for sharing
- App Links (app_links package) for deep linking
- Passwordless login support (lib/services/passwordless_login_services.dart)

## Project-Specific Conventions

### Models
- Extend `Equatable` for value equality
- Implement `fromMap()` and `toMap()` for Firestore serialization
- Use `copyWith()` for immutable updates

### Error Handling
```dart
try {
  await repository.fetchData();
} catch (e) {
  debugPrint('Error in FeatureBloc: $e');
  emit(state.copyWith(error: e.toString()));
}
```

Currently basic - avoid adding complex error types, use strings.

### Styling
- **ScreenUtil**: All sizes use `.w`, `.h`, `.sp` (flutter_screenutil)
- **Theme**: Light theme defined in common/theme/app_theme.dart
- **Localization**: AppTranslations for multi-language (French primary)

## Critical "Gotchas"

1. **Firestore Document ID ≠ User ID**: Always use `.where('id', isEqualTo: uid)`, not `.doc(uid)`
2. **Mixed State**: Don't add setState to screens that use BLoC
3. **GetX is for Navigation Only**: Never use GetxController or Obx
4. **HydratedBloc**: Some blocs (StoriesBloc, MatchBloc, WellcomeBloc) persist state
5. **Auto-login**: Commented out in app.dart _autoLogin() - don't re-enable in production

## When Adding New Features

1. **Create feature folder** in `lib/features/{feature_name}/`
2. **Always use BLoC pattern**: bloc/, repository/, model/, screen/
3. **Add route** to AppRoutes and app_pages.dart
4. **Use GetX navigation**: `Get.toNamed(AppRoutes.newFeature)`
5. **Follow existing patterns**: See similar features like home/, profile/, chat/
6. **Write tests**: Even minimal tests help (see TESTING_GUIDE.md)

## When Refactoring

Per DEVELOPER_GUIDE.md survival strategy:
1. **Map critical paths first** - don't break working features
2. **Refactor only what you touch** - don't fix unrelated code
3. **Add logging before changing** - track what breaks
4. **Small incremental changes** - one PR = one thing
5. **Document tech debt**: Use TODO/HACK/FIXME comments with context

## Resources

- [DEVELOPER_GUIDE.md](../DEVELOPER_GUIDE.md) - Comprehensive guide & survival strategy
- [CONNECTIVITY_GUIDE.md](../CONNECTIVITY_GUIDE.md) - Network monitoring details
- [TESTING_GUIDE.md](../TESTING_GUIDE.md) - Test patterns & examples
- [about_this_project.md](../about_this_project.md) - State management rules

---

**Remember**: This codebase is messy by design. Make it 1% better with each change, don't try to fix everything at once. Ship features, stabilize first, optimize later.
