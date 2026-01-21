# AfriQueen Developer Guide

> **Last Updated:** January 20, 2026  
> **Flutter SDK:** >=3.0.0 <4.0.0  
> **Version:** 1.0.0+1

---

## Table of Contents

1. [⚠️ Reality Check: Working with Legacy "Vibe Coded" Projects](#reality-check-working-with-legacy-vibe-coded-projects)
2. [Project Overview](#project-overview)
3. [Architecture](#architecture)
4. [Project Structure](#project-structure)
5. [State Management](#state-management)
6. [Data Layer](#data-layer)
7. [Navigation](#navigation)
8. [Localization](#localization)
9. [Styling & Theming](#styling--theming)
10. [Firebase Integration](#firebase-integration)
11. [Key Features](#key-features)
12. [Development Workflow](#development-workflow)
13. [Code Patterns & Best Practices](#code-patterns--best-practices)
14. [Common Issues & Solutions](#common-issues--solutions)
15. [Testing](#testing)
16. [Deployment](#deployment)
17. [Refactoring Strategy](#refactoring-strategy)

---

## ⚠️ Reality Check: Working with Legacy "Vibe Coded" Projects

### The Truth About This Codebase

Let's be honest: **This project was "vibe coded"** - built rapidly without proper planning, with inconsistent patterns, duplicate logic, and technical debt. You've probably noticed:

- ❌ **Duplicate code** (like/unlike logic in multiple places)
- ❌ **Inconsistent patterns** (some widgets use BLoC, others don't)
- ❌ **Mixed state management** (BLoC + GetX + setState everywhere)
- ❌ **No tests** (or minimal testing coverage)
- ❌ **Poor error handling** (try-catch blocks that don't help debugging)
- ❌ **Magic numbers and strings** scattered throughout
- ❌ **Verbose comments** like `//-------------------` instead of proper documentation
- ❌ **Over-engineered solutions** for simple problems
- ❌ **Under-engineered solutions** for complex problems
- ❌ **AI-generated boilerplate** that was never properly refactored

**This is common. You're not alone. Many production apps look like this.**

---

### Your Survival Strategy

#### 🛑 Phase 1: STOP and Assess (Week 1-2)

**DO NOT start "fixing everything" immediately.** You'll break things and waste time.

1. **Map the Critical Paths**
   - Identify the 5 most important user flows (login, signup, chat, matching, profile)
   - Test them thoroughly
   - Document any bugs you find
   - These are your "don't break" zones

2. **Create a Dependency Map**
   ```bash
   # Find what imports what
   grep -r "import 'package:afriqueen" lib/ > dependencies.txt
   ```
   - Identify highly coupled modules
   - These are risky to change

3. **Document Current State**
   - Take screenshots of working features
   - Record video walkthroughs
   - Write down current behavior (even if buggy)
   - This is your baseline

4. **Set Up Error Tracking**
   - Add Firebase Crashlytics properly
   - Add logging to critical functions
   - You need to know what's actually breaking

#### 🎯 Phase 2: Stabilize Before Optimizing (Month 1)

**Priority: Make it work reliably, not make it perfect.**

1. **Add Basic Logging**
   ```dart
   // Create a simple logger service
   class AppLogger {
     static void logError(String location, dynamic error, StackTrace? stack) {
       debugPrint('❌ [$location] $error');
       if (stack != null) debugPrint(stack.toString());
       // Send to Crashlytics
     }
     
     static void logInfo(String location, String message) {
       debugPrint('ℹ️ [$location] $message');
     }
   }
   
   // Use everywhere
   try {
     await repository.fetchData();
   } catch (e, stack) {
     AppLogger.logError('HomeBloc', e, stack);
   }
   ```

2. **Fix Critical Bugs First**
   - User can't login? Fix that.
   - App crashes on chat? Fix that.
   - Images won't upload? Fix that.
   - Polish can wait.

3. **Add Null Safety Guards**
   ```dart
   // Before: Crashes if null
   final name = user.name;
   
   // After: Graceful degradation
   final name = user?.name ?? 'Unknown User';
   ```

4. **Create Issue Tracker**
   - Use GitHub Issues, Jira, or even a Markdown file
   - Categorize: 🔴 Critical, 🟡 Important, 🟢 Nice to Have
   - Don't try to fix everything at once

#### 🔧 Phase 3: Strategic Refactoring (Month 2-3)

**The Boy Scout Rule: Leave the code better than you found it.**

1. **Refactor Only What You Touch**
   - Need to add a feature to chat? Refactor the chat module only
   - Don't refactor unrelated code "while you're at it"
   - One module at a time

2. **Extract Duplicate Code**
   ```dart
   // Found duplicate like button logic in 3 places?
   // Create ONE shared widget
   class SharedLikeButton extends StatefulWidget {
     final String userId;
     final Function(bool)? onLikeChanged;
     // Single source of truth
   }
   ```

3. **Add Tests for New Features**
   - Don't test old code (yet)
   - Test everything NEW you add
   - Build testing culture gradually

4. **Create Style Guide**
   - Document the patterns YOU want to follow
   - Enforce with linter rules (analysis_options.yaml)
   - Use `dart format` consistently

#### 🚀 Phase 4: Long-Term Improvements (Month 4+)

1. **Establish Code Review Process**
   - Every PR gets reviewed
   - Enforce standards
   - Share knowledge

2. **Gradual Modernization**
   - Replace GetX navigation with proper routing (one screen at a time)
   - Consolidate state management (choose BLoC or GetX, not both)
   - Remove unused dependencies

3. **Add Comprehensive Testing**
   - Start with integration tests for critical paths
   - Add unit tests for repositories
   - Widget tests for reusable components

4. **Performance Optimization**
   - Profile with Flutter DevTools
   - Fix memory leaks
   - Optimize images and API calls

---

### Practical Rules for This Codebase

#### ✅ DO:

1. **Ask "Does this work?" before "Is this clean?"**
   - Working messy code > broken clean code
   
2. **Make small, incremental changes**
   - One PR = One feature/fix
   - Easy to review, easy to revert

3. **Document your decisions**
   ```dart
   // TODO: Refactor this duplicate logic - see UserDetailsWidget line 234
   // HACK: Workaround for Firebase timestamp bug - remove when SDK updated
   // FIXME: This causes memory leak - needs investigation
   ```

4. **Use feature flags for risky changes**
   ```dart
   if (AppConfig.useNewChatUI) {
     return NewChatScreen();
   }
   return OldChatScreen(); // Fallback
   ```

5. **Write defensive code**
   ```dart
   if (data == null || data.isEmpty) {
     return EmptyState();
   }
   ```

#### ❌ DON'T:

1. **Don't rewrite from scratch**
   - You'll waste 6 months
   - You'll introduce new bugs
   - Users don't care about clean code, they care about features

2. **Don't refactor without tests**
   - You can't verify you didn't break anything
   - Add tests first, then refactor

3. **Don't change code you don't understand**
   - That "ugly" code might fix a critical bug
   - Ask team members or investigate git history

4. **Don't optimize prematurely**
   - Profile first
   - Fix actual bottlenecks, not imagined ones

5. **Don't judge previous developers**
   - They were under pressure
   - They had constraints you don't know about
   - Your code will look messy to someone else too

---

### Mental Health Tips

Working with messy code is **mentally exhausting**. Here's how to cope:

1. **Set Realistic Expectations**
   - You won't fix everything in a week
   - Progress > Perfection

2. **Celebrate Small Wins**
   - Fixed a crash? Win! 🎉
   - Removed duplicate code? Win! 🎉
   - Added a test? Win! 🎉

3. **Take Breaks**
   - When frustrated, step away
   - Code review is harder on messy code

4. **Find Allies**
   - Talk to other devs on the project
   - Share the burden
   - Pair program on tough issues

5. **Remember: It Gets Better**
   - Every refactor makes it easier
   - Future you will thank present you

---

### Emergency Decision Matrix

When you encounter a mess, use this:

| Situation | Action |
|-----------|--------|
| 🔴 Production is down | Fix ASAP, any way possible. Document "tech debt created" |
| 🟡 Feature request from business | Implement feature. If touching messy code, refactor just that area |
| 🟢 You have spare time | Pick one module, refactor properly, add tests |
| ⚠️ Not sure if code is needed | Leave it alone. Add comment: "// Purpose unclear - investigate before removing" |
| 💡 Want to try new architecture | Create proof-of-concept in new feature, don't touch existing |

---

### The Bottom Line

**This codebase is messy, but it's YOUR codebase now.**

- Accept reality ✅
- Make a plan 📋
- Execute methodically 🎯
- Document everything 📝
- Don't burn out 🔥
- Ship features 🚀

You can't fix everything at once. But you can make it 1% better every day.

**In 6 months, you'll look back and see real progress. Trust the process.**

---

## Project Overview

**AfriQueen** is a Flutter-based dating/social networking application with the following core functionality:

- User authentication (email/password, Google Sign-In, passwordless login via dynamic links)
- User profiles with detailed preferences and interests
- Match/like system
- Real-time chat messaging
- Stories feature
- Events and meetings
- Premium subscription features
- Gift sending system
- Location-based user discovery
- Invisible mode
- User blocking and reporting

### Target Platforms
- Android ✅
- iOS ✅
- Web ✅
- Linux ✅
- macOS ✅
- Windows ✅

---

## Architecture

### Overall Architecture Pattern

The app follows a **Feature-First Clean Architecture** with:

1. **BLoC Pattern** (Business Logic Component) for state management
2. **Repository Pattern** for data abstraction
3. **Service Layer** for cross-cutting concerns
4. **Model-View-BLoC** structure within each feature

```
┌─────────────┐
│     UI      │ (Widgets/Screens)
└──────┬──────┘
       │
┌──────▼──────┐
│    BLoC     │ (Business Logic)
└──────┬──────┘
       │
┌──────▼──────┐
│ Repository  │ (Data Access)
└──────┬──────┘
       │
┌──────▼──────┐
│  Firebase   │ (Backend)
│  Storage    │
│  Services   │
└─────────────┘
```

### Key Architectural Decisions

1. **Feature-First Organization:** Each feature is self-contained with its own models, repositories, BLoCs, screens, and widgets
2. **Separation of Concerns:** Clear boundaries between UI, business logic, and data layers
3. **Dependency Injection:** Repositories and services are injected where needed
4. **Reactive Programming:** BLoC pattern with streams for reactive UI updates
5. **State Persistence:** HydratedBloc for persisting state across app restarts

---

## Project Structure

```
lib/
├── main.dart                     # App entry point
├── app.dart                      # Root widget (routes, theme, localization)
├── firebase_options.dart         # Firebase configuration
│
├── common/                       # Shared resources
│   ├── constant/
│   │   ├── constant_colors.dart  # App color palette
│   │   └── constant_strings.dart # App-wide string constants
│   ├── theme/
│   │   └── app_theme.dart        # Light/dark theme definitions
│   ├── widgets/                  # Reusable UI components
│   │   ├── common_button.dart
│   │   ├── snackbar_message.dart
│   │   ├── user_status.dart
│   │   └── seniority.dart
│   ├── localization/             # i18n support
│   │   ├── enums/
│   │   │   └── enums.dart        # Locale enum keys
│   │   ├── language/
│   │   │   ├── en_us.dart        # English translations
│   │   │   └── fr_fr.dart        # French translations
│   │   └── translations/
│   │       └── app_translations.dart
│   └── utils/                    # Helper functions
│
├── services/                     # App-wide services
│   ├── storage/                  # Local storage (SharedPrefs, GetStorage)
│   ├── location/                 # GPS/geolocation services
│   ├── permissions/              # Runtime permissions
│   ├── connectivity/             # Network status
│   ├── distance/                 # Distance calculation
│   ├── notifications/            # Push notifications
│   ├── firebase/                 # Firebase helpers
│   ├── status/                   # User online status
│   ├── invisible_mode_service.dart
│   ├── premium_service.dart
│   └── passwordless_login_services.dart
│
├── features/                     # Feature modules
│   ├── auth/
│   │   ├── bloc/                # Authentication BLoC
│   │   ├── repository/          # Auth data layer
│   │   ├── screen/              # Login/signup screens
│   │   └── widgets/             # Auth-specific widgets
│   ├── home/
│   │   ├── model/               # HomeModel (user card data)
│   │   ├── repository/          # Home data fetching
│   │   ├── bloc/                # Home state management
│   │   ├── screen/              # Main discovery screen
│   │   └── widgets/             # User cards, filters
│   ├── profile/                 # User profile viewing
│   ├── edit_profile/            # Profile editing
│   ├── create_profile/          # Onboarding profile creation
│   ├── chat/                    # Real-time messaging
│   ├── match/                   # Like/unlike system
│   ├── favorite/                # Favorites management
│   ├── archive/                 # Archived profiles
│   ├── blocked/                 # Blocked users
│   ├── stories/                 # Story creation/viewing
│   ├── reels/                   # Video content
│   ├── event/                   # Events/meetings
│   ├── gifts/                   # Gift sending system
│   ├── setting/                 # App settings
│   ├── user_details/            # Detailed profile view
│   ├── activity/                # User activity tracking
│   ├── visibility/              # Invisible mode
│   ├── report_profile/          # User reporting
│   ├── email_verification/      # Email verification
│   ├── forgot_password/         # Password reset
│   └── wellcome/                # Onboarding screens
│
├── routes/
│   ├── app_routes.dart          # Route constants
│   └── app_pages.dart           # Route configuration
│
└── core/                        # Core utilities (if any)
```

### Feature Structure (Standard Pattern)

Each feature typically follows this structure:

```
feature_name/
├── model/
│   └── feature_model.dart       # Data models
├── repository/
│   └── feature_repository.dart  # Data access layer
├── bloc/
│   ├── feature_bloc.dart        # Business logic
│   ├── feature_event.dart       # Events
│   └── feature_state.dart       # States
├── screen/
│   └── feature_screen.dart      # UI screens
└── widgets/
    └── feature_widgets.dart     # Feature-specific widgets
```

---

## State Management

### BLoC Pattern

The app uses **flutter_bloc** (v9.1.1) for state management with **HydratedBloc** for persistence.

#### BLoC Lifecycle

```dart
// 1. Define Events
abstract class HomeEvent extends Equatable {}

class HomeUsersFetched extends HomeEvent {
  @override
  List<Object?> get props => [];
}

// 2. Define States
abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {}
class Loading extends HomeState {}
class HomeDataLoaded extends HomeState {
  final List<HomeModel> users;
  HomeDataLoaded({required this.users});
  
  @override
  List<Object?> get props => [users];
}

// 3. Implement BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;
  
  HomeBloc({required HomeRepository repo})
      : _repository = repo,
        super(HomeInitial()) {
    on<HomeUsersFetched>(_onUsersFetched);
  }
  
  Future<void> _onUsersFetched(
    HomeUsersFetched event,
    Emitter<HomeState> emit,
  ) async {
    emit(Loading());
    try {
      final users = await _repository.fetchAllExceptCurrentUser();
      emit(HomeDataLoaded(users: users));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
```

#### Using BLoC in UI

```dart
// Provide BLoC
BlocProvider(
  create: (context) => HomeBloc(repo: HomeRepository())
    ..add(HomeUsersFetched()),
  child: HomeScreen(),
)

// Listen to state changes
BlocBuilder<HomeBloc, HomeState>(
  builder: (context, state) {
    if (state is Loading) return CircularProgressIndicator();
    if (state is HomeDataLoaded) return UserList(users: state.users);
    return ErrorWidget();
  },
)

// Dispatch events
context.read<HomeBloc>().add(HomeUsersFetched());
```

### HydratedBloc (State Persistence)

```dart
// Setup in main.dart
HydratedBloc.storage = await HydratedStorage.build(
  storageDirectory: kIsWeb
      ? HydratedStorageDirectory.web
      : HydratedStorageDirectory((await getTemporaryDirectory()).path),
);

// Implement in BLoC
class FavoriteBloc extends HydratedBloc<FavoriteEvent, FavoriteState> {
  @override
  FavoriteState? fromJson(Map<String, dynamic> json) {
    return FavoriteState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(FavoriteState state) {
    return state.toJson();
  }
}
```

### Key BLoCs in the App

| BLoC | Purpose | Persisted |
|------|---------|-----------|
| `HomeBloc` | User discovery feed | No |
| `ChatBloc` | Chat messages | No |
| `FavoriteBloc` | Favorite users | Yes |
| `ArchiveBloc` | Archived users | Yes |
| `BlockedBloc` | Blocked users | Yes |
| `ProfileBloc` | Current user profile | Yes |
| `LoginBloc` | Authentication | No |
| `StoriesBloc` | Stories management | No |

---

## Data Layer

### Repository Pattern

Repositories abstract data sources (Firebase Firestore, Storage, Auth) from business logic.

#### Standard Repository Structure

```dart
class HomeRepository {
  final FirebaseFirestore firebaseFirestore;
  
  HomeRepository({FirebaseFirestore? firestore})
    : firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  Future<List<HomeModel>> fetchAllExceptCurrentUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      
      final snapshot = await firebaseFirestore
          .collection('user')
          .get();
      
      // Filter out current user
      final filteredDocs = snapshot.docs.where((doc) {
        final docId = doc.data()['id'] as String? ?? '';
        return docId != uid;
      }).toList();
      
      return filteredDocs.map((doc) => 
        HomeModel.fromJson(doc.data())
      ).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}
```

#### Key Repositories

| Repository | Collection(s) | Purpose |
|------------|---------------|---------|
| `HomeRepository` | `user` | User discovery |
| `ChatRepository` | `chats`, `messages` | Messaging |
| `ProfileRepository` | `user` | Profile CRUD |
| `LikeRepository` | `likes` | Match system |
| `FavoriteRepository` | `favorites` | Favorites management |
| `ArchiveRepository` | `archives` | Archived users |
| `BlockedRepository` | `blocked` | Block management |
| `StoriesRepository` | `stories` | Stories CRUD |
| `EventRepository` | `events` | Events management |

### Data Models

All models follow this pattern:

```dart
class HomeModel extends Equatable {
  final String id;
  final String pseudo;
  final int age;
  final String gender;
  final List<String> photos;
  final String city;
  final String country;
  final List<String> mainInterests;
  final String description;
  final bool isElite;
  final DateTime createdDate;
  
  const HomeModel({
    required this.id,
    required this.pseudo,
    required this.age,
    // ...
  });
  
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'] ?? '',
      pseudo: json['pseudo'] ?? '',
      age: json['age'] ?? 0,
      // ...
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pseudo': pseudo,
      'age': age,
      // ...
    };
  }
  
  @override
  List<Object?> get props => [id, pseudo, age, ...];
}
```

---

## Navigation

### Navigation System

The app uses **GetX** (v4.7.2) for navigation alongside named routes.

#### Route Definitions

```dart
// lib/routes/app_routes.dart
class AppRoutes {
  static const initial = '/';
  static const signup = '/signup';
  static const login = '/login';
  static const main = '/main';
  static const profile = '/profile';
  static const chat = '/chat';
  static const setting = '/setting';
  // ... more routes
}
```

#### Route Configuration

```dart
// lib/routes/app_pages.dart => Provider navigation routers is used mostly not get 
class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
    ),
    // ...
  ];
}
```

#### Navigation Usage

```dart
// Push named route
Get.toNamed(AppRoutes.profile);

// Push with arguments
Get.toNamed(AppRoutes.chat, arguments: {'chatId': '123'});

// Push widget directly
Get.to(() => UserDetailsScreen(data: model));

// Replace route
Get.offNamed(AppRoutes.main);

// Go back
Get.back();

// Go back with result
Get.back(result: {'success': true});
```

---

## Localization

### Multi-Language Support

The app supports **English (en_US)** and **French (fr_FR)** using GetX translations.

#### Localization Setup

```dart
// lib/app.dart
GetMaterialApp(
  translations: AppTranslations(),
  locale: Get.deviceLocale,
  fallbackLocale: Locale('en', 'US'),
  // ...
)
```

#### Translation Files

```dart
// lib/common/localization/language/en_us.dart
final Map<String, String> enUS = {
  'welcome': 'Welcome',
  'login': 'Login',
  'signup': 'Sign Up',
  // ... hundreds more
};

// lib/common/localization/language/fr_fr.dart
final Map<String, String> frFR = {
  'welcome': 'Bienvenue',
  'login': 'Connexion',
  'signup': 'S\'inscrire',
  // ...
};
```

#### Using Translations

```dart
// Enum-based approach (recommended)
import 'package:afriqueen/common/localization/enums/enums.dart';

Text(EnumLocale.welcome.name.tr)

// Direct key approach
Text('welcome'.tr)

// With parameters
Text('welcome_user'.trParams({'name': 'John'}))
```

#### Adding New Translations

1. Add key to `enums.dart`:
   ```dart
   enum EnumLocale {
     welcome,
     newKey,  // Add here
   }
   ```

2. Add translations to both language files:
   ```dart
   // en_us.dart
   'newKey': 'New English Text',
   
   // fr_fr.dart
   'newKey': 'Nouveau texte français',
   ```

3. Use in code:
   ```dart
   Text(EnumLocale.newKey.name.tr)
   ```

---

## Styling & Theming

### Theme Configuration

```dart
// lib/common/theme/app_theme.dart
ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.floralWhite,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.floralWhite,
    elevation: 0.0,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.black,
      fontSize: 26.sp,  // ScreenUtil responsive
      fontFamily: AppStrings.robotosSemiBold,
    ),
    bodyMedium: TextStyle(
      color: AppColors.black,
      fontSize: 16.sp,
      fontFamily: AppStrings.robotoLight,
    ),
    bodySmall: TextStyle(
      color: AppColors.grey,
      fontSize: 15.sp,
      fontFamily: AppStrings.robotThin,
    ),
  ),
);
```

### Color Palette

```dart
// lib/common/constant/constant_colors.dart
class AppColors {
  static const Color floralWhite = Color(0xfffbf8f1);  // Background
  static const Color primaryColor = Color(0xffea1e63);  // Pink/magenta
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color red = Colors.red;
  static const Color blue = Colors.blue;
  static const Color green = Colors.green;
  
  // Accent colors
  static const Color orangeAccent = Color(0xFFFF6B6B);
  static const Color lightOrange = Color(0xFFFFE5E5);
  static const Color darkGrey = Color(0xFF666666);
  static const Color lightGrey = Color(0xFFF5F5F5);
}
```

### Responsive Design

The app uses **flutter_screenutil** (v5.9.3) for responsive sizing:

```dart
// Initialize in main widget
ScreenUtilInit(
  designSize: Size(375, 812),  // iPhone 11 Pro size
  builder: (context, child) => MyApp(),
)

// Usage
Container(
  width: 100.w,    // Responsive width
  height: 50.h,    // Responsive height
  padding: EdgeInsets.all(16.r),  // Responsive padding
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 18.sp),  // Responsive font
  ),
)
```

---

## Firebase Integration

### Firebase Services Used

1. **Firebase Authentication** - Email/password, Google Sign-In
2. **Cloud Firestore** - NoSQL database
3. **Firebase Storage** - Image/video uploads
4. **Firebase Dynamic Links** - Deep linking, passwordless auth; depricated now so used applinks
5. **Realtime Database** - Chat messages, online status

### Firestore Collections

| Collection | Document ID | Purpose |
|------------|-------------|---------|
| `user` | User UID | User profiles |
| `chats` | Chat ID | Chat metadata |
| `messages` | Message ID | Chat messages |
| `likes` | Like ID | User likes/matches |
| `favorites` | Favorite ID | Favorited users |
| `archives` | Archive ID | Archived users |
| `blocked` | Block ID | Blocked users |
| `stories` | Story ID | User stories |
| `events` | Event ID | Events/meetings |
| `gifts` | Gift ID | Gift transactions |
| `reports` | Report ID | User reports |

### Firestore Document Structure Examples

#### User Document
```javascript
{
  id: "user_uid",
  pseudo: "JohnDoe",
  email: "john@example.com",
  age: 28,
  gender: "male",
  orientation: "heterosexual",
  city: "Paris",
  country: "France",
  photos: ["url1", "url2", "url3"],
  mainInterests: ["travel", "music", "sports"],
  description: "Hello world...",
  whatLookingFor: "Serious relationship",
  whatNotWant: "Drama",
  relationshipStatus: "single",
  isElite: false,
  isPremium: false,
  isInvisible: false,
  createdDate: Timestamp,
  lastActive: Timestamp
}
```

#### Chat Document
```javascript
{
  id: "chat_id",
  participants: ["uid1", "uid2"],
  participantDetails: {
    uid1: { name: "John", photoUrl: "url" },
    uid2: { name: "Jane", photoUrl: "url" }
  },
  lastMessage: "Hey!",
  lastMessageTime: Timestamp,
  unreadCount: { uid1: 0, uid2: 2 }
}
```

### Firebase Security Rules

**Important:** Ensure proper security rules are configured in `firestore.rules`.

---

## Key Features

### 1. Authentication Flow

```
Splash Screen → Check Auth State
    ├─ Authenticated → Main Screen
    └─ Not Authenticated → Login/Signup
        ├─ Email/Password
        ├─ Google Sign-In
        └─ Passwordless (firebase Dynamic Links is depricated now, so use applinks only)
```

**Passwordless Authentication:**
- Implemented via Firebase Dynamic Links
- Email link sent to user
- User clicks link → auto-login
- Handled in `app.dart` via `_initDynamicLinks()`

### 2. Profile Creation Flow

```
Signup → Email Verification → Profile Creation Steps:
  1. Name
  2. Gender & Orientation
  3. Age
  4. Address (City/Country via GPS)
  5. Interests Selection
  6. Photo Upload (1-5 photos)
  7. Description
  → Profile Complete → Main Screen
```

### 3. User Discovery (Home Screen)

- **Card Swiper:** Swipe right to like, left to pass
- **Filters:** Age, distance, gender, orientation
- **Blocked/Archived:** Automatically filtered out
- **Location-Based:** Shows distance from current user
- **Premium Features:** See who liked you, unlimited likes

### 4. Chat System

- **Real-time messaging** via Firebase Realtime Database
- **Message types:** Text, images, audio, video
- **Read receipts:** Track message read status
- **Typing indicators:** Show when user is typing
- **Chat requests:** Users must match or accept chat

### 5. Stories Feature

- Upload photo/video stories (24-hour expiration)
- View friends' stories
- Story viewer with progress indicator
- Analytics: view count, viewers list

### 6. Premium Features

- **Unlimited likes**
- **See who liked you**
- **Invisible mode** (browse anonymously)
- **Priority profile** (appear first in discovery)
- **Advanced filters**
- **Rewind** (undo swipes)

### 7. Gift System

- Send virtual gifts to users
- Gift catalog with different tiers
- Gift recharge system (periodic credits)
- Gift notification system

---

## Development Workflow

### Prerequisites

- Flutter SDK >=3.0.0
- Dart SDK >=3.0.0
- Android Studio / Xcode (for mobile development)
- Firebase CLI
- Git

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone <repo-url>
   cd afriqueen
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   - Ensure `firebase_options.dart` is present
   - Add `google-services.json` (Android)
   - Add `GoogleService-Info.plist` (iOS)

4. **Run the app:**
   ```bash
   flutter run
   ```

### Build Commands

```bash
# Debug build
flutter run -d <device-id>

# Release build (Android)
flutter build apk --release
flutter build appbundle --release

# Release build (iOS)
flutter build ios --release
flutter build ipa --release

# Web build
flutter build web --release
```

### Code Generation

```bash
# Generate build_runner files (if any)
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Code Patterns & Best Practices

### 1. Widget Extraction

**Bad:**
```dart
// Monolithic widget
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 200 lines of complex UI...
        ],
      ),
    );
  }
}
```

**Good:**
```dart
// Extracted widgets
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Column(
        children: [
          UserFilters(),
          Expanded(child: UserCardSwiper()),
        ],
      ),
    );
  }
}
```

### 2. State Management

**Bad:**
```dart
// Direct Firebase calls in UI
onPressed: () async {
  final data = await FirebaseFirestore.instance
      .collection('user')
      .doc(userId)
      .get();
  setState(() {
    user = data.data();
  });
}
```

**Good:**
```dart
// BLoC pattern
onPressed: () {
  context.read<ProfileBloc>().add(ProfileFetched(userId: userId));
}

// In UI
BlocBuilder<ProfileBloc, ProfileState>(
  builder: (context, state) {
    if (state is ProfileLoaded) return ProfileWidget(state.user);
    // ...
  },
)
```

### 3. Error Handling

```dart
try {
  final result = await repository.fetchData();
  emit(DataLoaded(data: result));
} on FirebaseException catch (e) {
  emit(DataError(message: e.message ?? 'Firebase error'));
} on NetworkException catch (e) {
  emit(DataError(message: 'Network error: ${e.message}'));
} catch (e) {
  emit(DataError(message: 'Unexpected error: $e'));
  debugPrint('Error in HomeBloc: $e');
}
```

### 4. Null Safety

```dart
// Always handle null cases
final userName = userData['name'] as String? ?? 'Unknown';
final photos = (userData['photos'] as List?)?.cast<String>() ?? [];

// Use null-aware operators
user?.updateProfile(name: 'John');
final age = user?.age ?? 0;
```

### 5. Constants & Magic Numbers

**Bad:**
```dart
Container(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16),
)
```

**Good:**
```dart
// Define constants
class AppSizes {
  static const double cardWidth = 200;
  static const double cardHeight = 100;
  static const double defaultPadding = 16;
}

Container(
  width: AppSizes.cardWidth.w,
  height: AppSizes.cardHeight.h,
  padding: EdgeInsets.all(AppSizes.defaultPadding.r),
)
```

### 6. Async Operations

```dart
// Always use async/await with try-catch
Future<void> loadData() async {
  try {
    setState(() => isLoading = true);
## Refactoring Strategy

### Quick Wins (Do These First)

These refactorings are low-risk and high-impact:

#### 1. Consolidate Duplicate Like Logic

**Problem:** Like/unlike logic duplicated in `ActionButtonsRow` and `ButtonList`.

**Solution:**
```dart
// lib/common/widgets/like_button.dart
class LikeButton extends StatefulWidget {
  final String userId;
  final VoidCallback? onLikeSuccess;
  
  const LikeButton({
    required this.userId,
    this.onLikeSuccess,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  bool isLoading = true;
  final LikeRepository _repository = LikeRepository();

  @override
  void initState() {
    super.initState();
    _checkLikeStatus();
  }

  Future<void> _checkLikeStatus() async {
    final liked = await _repository.hasLikedUser(widget.userId);
    if (mounted) {
      setState(() {
        isLiked = liked;
        isLoading = false;
      });
    }
  }

  Future<void> _toggleLike() async {
    setState(() => isLoading = true);
    try {
      if (isLiked) {
        await _repository.unlikeUser(widget.userId);
      } else {
        await _repository.likeUser(widget.userId);
      }
      if (mounted) {
        setState(() {
          isLiked = !isLiked;
          isLoading = false;
        });
        widget.onLikeSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        // Show error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isLoading ? null : _toggleLike,
      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
    );
  }
}

// Now use everywhere - single source of truth
```

#### 2. Create Reusable Error Handler

**Problem:** Inconsistent error handling across the app.

**Solution:**
```dart
// lib/common/utils/error_handler.dart
class ErrorHandler {
  static String getUserMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      return _getAuthErrorMessage(error);
    } else if (error is FirebaseException) {
      return _getFirebaseErrorMessage(error);
    } else if (error is NetworkException) {
      return 'No internet connection';
    }
    return 'Something went wrong. Please try again.';
  }
  
  static void showErrorSnackbar(BuildContext context, dynamic error) {
    final message = getUserMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  static Future<T?> handleAsync<T>(
    Future<T> Function() operation, {
    required BuildContext context,
  }) async {
    try {
      return await operation();
    } catch (e, stack) {
      AppLogger.logError('ErrorHandler', e, stack);
      showErrorSnackbar(context, e);
      return null;
    }
  }
}

// Usage
await ErrorHandler.handleAsync(
  () => repository.updateProfile(data),
  context: context,
);
```

#### 3. Standardize Loading States

**Problem:** Loading indicators everywhere, inconsistent.

**Solution:**
```dart
// lib/common/widgets/loading_overlay.dart
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  if (message != null) ...[
                    SizedBox(height: 16),
                    Text(message!, style: TextStyle(color: Colors.white)),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// Usage - consistent everywhere
LoadingOverlay(
  isLoading: state is Loading,
  child: YourContent(),
)
```

#### 4. Extract Constants

**Problem:** Magic numbers and strings everywhere.

**Solution:**
```dart
// lib/common/constant/app_constants.dart
class AppConstants {
  // Sizes
  static const double defaultPadding = 16.0;
  static const double cardRadius = 12.0;
  static const double avatarSize = 48.0;
  
  // Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration toastDuration = Duration(seconds: 3);
  
  // Limits
  static const int maxPhotos = 5;
  static const int minAge = 18;
  static const int maxAge = 100;
  static const int bioMaxLength = 500;
  
  // Validation
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  // Firestore
  static const String usersCollection = 'user';
  static const String chatsCollection = 'chats';
  static const String likesCollection = 'likes';
}

// Use everywhere
Container(
  padding: EdgeInsets.all(AppConstants.defaultPadding.r),
  // ...
)
```

#### 5. Remove Verbose Comments

**Problem:** Comments like `//-------------------Profile Image Gallery------------------------------`

**Solution:** Delete them. If the code needs explanation, use proper doc comments:

```dart
/// Displays a user's profile image gallery with a main image
/// and up to 4 thumbnail previews.
/// 
/// Tapping on the main image or thumbnails opens a full-screen viewer.
class ProfileImageGallery extends StatelessWidget {
  // ...
}
```

---

### Module-by-Module Refactoring Roadmap

#### Priority 1: Authentication (Week 1-2)
- [ ] Consolidate login/signup logic
- [ ] Add proper error messages
- [ ] Add form validation
- [ ] Test email verification flow
- [ ] Document passwordless login

#### Priority 2: Chat System (Week 3-4)
- [ ] Fix message loading performance
- [ ] Add message retry on failure
- [ ] Consolidate chat repository
- [ ] Add offline support
- [ ] Test real-time updates

#### Priority 3: User Discovery/Home (Week 5-6)
- [ ] Optimize user fetching
- [ ] Fix filter logic
- [ ] Add pagination
- [ ] Cache user data
- [ ] Test blocking/archiving

#### Priority 4: Profile Management (Week 7-8)
- [ ] Consolidate profile edit logic
- [ ] Optimize image uploads
- [ ] Add validation
- [ ] Test data persistence

#### Priority 5: Everything Else (Month 3+)
- Stories, Events, Gifts, Settings, etc.

---

### Code Review Checklist

Before submitting any PR, check:

- [ ] Does it work? (Test on device)
- [ ] No new crashes?
- [ ] Follows existing patterns (for now)
- [ ] No hardcoded strings (use localization)
- [ ] No magic numbers (use constants)
- [ ] Error handling added
- [ ] Null safety considered
- [ ] Performance impact considered
- [ ] Documented complex logic
- [ ] Removed debug prints
- [ ] Updated DEVELOPER_GUIDE if needed

---

### Migration Guide: From Chaos to Order

Long-term goal: Move from current mess to clean architecture.

**Current State:**
```
❌ Mixed state management (BLoC + GetX + setState)
❌ No clear boundaries
❌ Tight coupling
❌ No tests
```

**Target State (12 months):**
```
✅ Single state management solution (BLoC)
✅ Clear layer separation
✅ Dependency injection
✅ 70%+ test coverage
✅ CI/CD pipeline
✅ Documentation
```

**Migration Steps:**

1. **Month 1-3:** Stabilize & Document
2. **Month 4-6:** Strategic refactoring (one module at a time)
3. **Month 7-9:** Add comprehensive testing
4. **Month 10-12:** Performance optimization & polish

---

**For Questions or Contributions:**  
Please follow the project's contribution guidelines and reach out to the development team.

**Remember:** Every large, successful app started as a mess. The difference is that someone decided to make it better, one commit at a time. That someone is you
      setState(() {
        this.data = data;
        isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() => isLoading = false);
      showError(e.toString());
    }
  }
}
```

### 7. Image Optimization

```dart
// Use CachedNetworkImage for remote images
CachedNetworkImage(
  imageUrl: photoUrl,
  fit: BoxFit.cover,
  placeholder: (context, url) => Shimmer(...),
  errorWidget: (context, url, error) => PlaceholderImage(),
  memCacheWidth: 800,  // Limit memory usage
)
```

### 8. Performance Tips

- Use `const` constructors wherever possible
- Avoid rebuilding widgets unnecessarily (use `const`, `keys`)
- Lazy load images and data
- Use `ListView.builder` instead of `ListView` for long lists
- Profile the app regularly using Flutter DevTools

---

## Common Issues & Solutions

### Issue 1: Current User Appearing in Discovery Feed

**Problem:** Current user's profile shows up in home feed.

**Solution:** Filter by both document ID and `id` field:
```dart
final filteredDocs = snapshot.docs.where((doc) {
  final docId = doc.data()['id'] as String? ?? '';
  final documentId = doc.id;
  return docId != uid && documentId != uid;
}).toList();
```

### Issue 2: State Not Persisting After App Restart

**Problem:** User preferences reset on app restart.

**Solution:** Use HydratedBloc:
```dart
class MyBloc extends HydratedBloc<MyEvent, MyState> {
  @override
  MyState? fromJson(Map<String, dynamic> json) {
    return MyState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(MyState state) {
    return state.toJson();
  }
}
```

### Issue 3: Firebase Timestamp Parsing Errors

**Problem:** Firestore Timestamps cause JSON parsing errors.

**Solution:**
```dart
factory HomeModel.fromJson(Map<String, dynamic> json) {
  DateTime parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }
  
  return HomeModel(
    createdDate: parseDate(json['createdDate']),
    // ...
  );
}
```

### Issue 4: Duplicate Logic in Multiple Widgets

**Problem:** Like button logic duplicated in `ActionButtonsRow` and `ButtonList`.

**Solution:** Extract to a shared widget or service:
```dart
class LikeButton extends StatefulWidget {
  final String userId;
  const LikeButton({required this.userId});
  // Implement once, reuse everywhere
}
```

### Issue 5: Memory Leaks from Unclosed Streams

**Problem:** BLoC streams not closed properly.

**Solution:**
```dart
@override
Future<void> close() {
  _subscriptions.cancel();  // Cancel all subscriptions
  return super.close();
}
```

---

## Testing

### Unit Testing

```dart
// test/features/home/repository/home_repository_test.dart
void main() {
  late HomeRepository repository;
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    repository = HomeRepository(firestore: mockFirestore);
  });

  test('fetchAllExceptCurrentUser returns filtered list', () async {
    // Arrange
    when(mockFirestore.collection('user').get())
        .thenAnswer((_) async => mockSnapshot);

    // Act
    final result = await repository.fetchAllExceptCurrentUser();

    // Assert
    expect(result.length, 5);
    expect(result.any((u) => u.id == currentUserId), false);
  });
}
```

### Widget Testing

```dart
testWidgets('Login button triggers authentication', (tester) async {
  await tester.pumpWidget(MyApp());
  
  await tester.enterText(find.byKey(Key('email')), 'test@test.com');
  await tester.enterText(find.byKey(Key('password')), 'password');
  await tester.tap(find.byKey(Key('loginButton')));
  
  await tester.pump();
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### Integration Testing

```bash
# Run integration tests
flutter drive --target=test_driver/app.dart
```

---

## Deployment

### Android

1. **Configure signing:**
   - Create keystore: `keytool -genkey -v -keystore ~/key.jks ...`
   - Add to `android/key.properties`
   - Update `android/app/build.gradle`

2. **Build release:**
   ```bash
   flutter build appbundle --release
   ```

3. **Upload to Play Console**

### iOS

1. **Configure signing in Xcode:**
   - Open `ios/Runner.xcworkspace`
   - Select signing team
   - Configure provisioning profiles

2. **Build release:**
   ```bash
   flutter build ipa --release
   ```

3. **Upload to App Store Connect:**
   - Use Xcode or Transporter app

### Web

```bash
flutter build web --release
```

Deploy to Firebase Hosting:
```bash
firebase deploy --only hosting
```

---

## Additional Resources

### Documentation Links

- [Flutter Docs](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [BLoC Library](https://bloclibrary.dev/)
- [GetX Documentation](https://pub.dev/packages/get)

### Useful Packages

| Package | Purpose | Version |
|---------|---------|---------|
| `flutter_bloc` | State management | 9.1.1 |
| `get` | Navigation & utils | 4.7.2 |
| `flutter_screenutil` | Responsive sizing | 5.9.3 |
| `cached_network_image` | Image caching | 3.3.1 |
| `cloud_firestore` | Firestore database | 4.9.1 |
| `firebase_auth` | Authentication | 5.5.3 |
| `geolocator` | Location services | 14.0.0 |
| `image_picker` | Photo selection | 1.0.4 |
| `audioplayers` | Audio playback | 5.2.1 |

---

## Conclusion

This guide covers the essential aspects of the AfriQueen app architecture and development patterns. For specific implementation details, refer to the codebase and inline documentation.

**Key Takeaways:**

✅ Feature-first architecture with clear separation of concerns  
✅ BLoC pattern for predictable state management  
✅ Repository pattern for data abstraction  
✅ Comprehensive Firebase integration  
✅ Multi-language support (en, fr)  
✅ Responsive design with ScreenUtil  
✅ Modular, maintainable code structure  

**Next Steps for Developers:**

1. Familiarize yourself with the BLoC pattern
2. Understand the repository structure
3. Review Firebase security rules
4. Set up your development environment
5. Read feature-specific documentation in each module
6. Run the app and explore the user flows
7. Review existing code patterns before adding new features

---

**For Questions or Contributions:**  
Please follow the project's contribution guidelines and reach out to the development team.

**Last Updated:** January 20, 2026
