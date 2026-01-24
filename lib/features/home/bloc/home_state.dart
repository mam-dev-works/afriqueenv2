import 'package:afriqueen/features/home/model/home_model.dart';

import 'package:equatable/equatable.dart';

/// HomeState manages all user lists for the home screen with CACHING optimization
///
/// **CACHING STRATEGY:**
/// - All users are fetched from Firebase ONCE via `HomeUsersFetched` event
/// - The data is cached in `state.data`
/// - All other lists are filtered LOCALLY from this cache (no additional Firebase calls)
/// - This dramatically reduces Firebase reads and improves performance
///
/// **Dedicated Lists:**
/// - `newProfileList`: New users (not in favorites, archives, or blocked) - FILTERED LOCALLY
/// - `likedProfileList`: Users that the current user has liked - FILTERED LOCALLY
/// - `favoritesProfileList`: Users in favorites - FILTERED LOCALLY
/// - `archiveProfileList`: Users in archive - FILTERED LOCALLY
/// - `allProfileList`: All users (except current user and blocked users) - FILTERED LOCALLY
///
/// **How it works:**
/// 1. `HomeUsersFetched` - Fetches ALL users from Firebase and caches in `state.data`
/// 2. `HomeUsersProfileList` - Filters new users from cache
/// 3. `FetchLikedUsers` - Fetches like IDs, filters users from cache
/// 4. `FetchFavoriteUsers` - Fetches favorite IDs, filters users from cache
/// 5. `FetchArchiveUsers` - Fetches archive IDs, filters users from cache
/// 6. `FetchAllUsers` - Filters all users from cache (excluding blocked)
///
/// **Usage throughout the application:**
/// ```dart
/// // Access a specific list from anywhere with HomeBloc
/// BlocBuilder<HomeBloc, HomeState>(
///   builder: (context, state) {
///     final newUsers = state.newProfileList;
///     final likedUsers = state.likedProfileList;
///     final favorites = state.favoritesProfileList;
///     final archived = state.archiveProfileList;
///     final allUsers = state.allProfileList;
///     // Use the lists as needed - all filtered locally!
///   }
/// )
/// ```
///
/// **The `profileList` property** contains the currently displayed list based on `selectedTabIndex`:
/// - Tab 0 (New): profileList = newProfileList
/// - Tab 1 (Liked): profileList = likedProfileList
/// - Tab 2 (Favorites): profileList = favoritesProfileList
/// - Tab 3 (Archive): profileList = archiveProfileList
/// - Tab 4 (All): profileList = allProfileList
///
/// **Performance Benefits:**
/// - ✅ Firebase is queried only ONCE for all users
/// - ✅ Switching tabs is instant (local filtering)
/// - ✅ Reduced Firebase costs
/// - ✅ Better user experience (faster loading)
class HomeState extends Equatable {
  final List<HomeModel?> data; // CACHED data from Firebase
  final List<HomeModel?> profileList; // Currently displayed list
  final int selectedTabIndex;

  // Dedicated lists for each category - ALL FILTERED LOCALLY from cache
  final List<HomeModel?> newProfileList;
  final List<HomeModel?> likedProfileList;
  final List<HomeModel?> favoritesProfileList;
  final List<HomeModel?> archiveProfileList;
  final List<HomeModel?> allProfileList;

  const HomeState({
    required this.data,
    required this.profileList,
    required this.selectedTabIndex,
    this.newProfileList = const [],
    this.likedProfileList = const [],
    this.favoritesProfileList = const [],
    this.archiveProfileList = const [],
    this.allProfileList = const [],
  });

  HomeState copyWith({
    List<HomeModel?>? data,
    List<HomeModel?>? profileList,
    int? selectedTabIndex,
    List<HomeModel?>? newProfileList,
    List<HomeModel?>? likedProfileList,
    List<HomeModel?>? favoritesProfileList,
    List<HomeModel?>? archiveProfileList,
    List<HomeModel?>? allProfileList,
  }) =>
      HomeState(
        data: data ?? this.data,
        profileList: profileList ?? this.profileList,
        selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
        newProfileList: newProfileList ?? this.newProfileList,
        likedProfileList: likedProfileList ?? this.likedProfileList,
        favoritesProfileList: favoritesProfileList ?? this.favoritesProfileList,
        archiveProfileList: archiveProfileList ?? this.archiveProfileList,
        allProfileList: allProfileList ?? this.allProfileList,
      );

  factory HomeState.initial() {
    return HomeState(
      data: [],
      profileList: [],
      selectedTabIndex: 0,
      newProfileList: [],
      likedProfileList: [],
      favoritesProfileList: [],
      archiveProfileList: [],
      allProfileList: [],
    );
  }

  @override
  List<Object> get props => [
        data,
        profileList,
        selectedTabIndex,
        newProfileList,
        likedProfileList,
        favoritesProfileList,
        archiveProfileList,
        allProfileList
      ];
}

final class HomeInitial extends HomeState {
  HomeInitial()
      : super(
          data: [],
          profileList: [],
          selectedTabIndex: 0,
          newProfileList: [],
          likedProfileList: [],
          favoritesProfileList: [],
          archiveProfileList: [],
          allProfileList: [],
        );
}

final class Loading extends HomeState {
  Loading.fromState(HomeState state)
      : super(
          data: state.data,
          profileList: state.profileList,
          selectedTabIndex: state.selectedTabIndex,
          newProfileList: state.newProfileList,
          likedProfileList: state.likedProfileList,
          favoritesProfileList: state.favoritesProfileList,
          archiveProfileList: state.archiveProfileList,
          allProfileList: state.allProfileList,
        );
}

final class Error extends HomeState {
  final String error;
  Error.fromState(HomeState state, {required this.error})
      : super(
          data: state.data,
          profileList: state.profileList,
          selectedTabIndex: state.selectedTabIndex,
          newProfileList: state.newProfileList,
          likedProfileList: state.likedProfileList,
          favoritesProfileList: state.favoritesProfileList,
          archiveProfileList: state.archiveProfileList,
          allProfileList: state.allProfileList,
        );
  @override
  List<Object> get props => [error];
}

final class HomeDataIsEmpty extends HomeState {
  HomeDataIsEmpty.fromState(HomeState state)
      : super(
          data: state.data,
          profileList: state.profileList,
          selectedTabIndex: state.selectedTabIndex,
          newProfileList: state.newProfileList,
          likedProfileList: state.likedProfileList,
          favoritesProfileList: state.favoritesProfileList,
          archiveProfileList: state.archiveProfileList,
          allProfileList: state.allProfileList,
        );
}
