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
/// - `newUserList`: New users (not in favorites, archives, or blocked) - FILTERED LOCALLY
/// - `likedUserList`: Users that the current user has liked - FILTERED LOCALLY
/// - `favoritesUserList`: Users in favorites - FILTERED LOCALLY
/// - `archiveUserList`: Users in archive - FILTERED LOCALLY
/// - `allUserList`: All users (except current user and blocked users) - FILTERED LOCALLY
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
///     final newUsers = state.newUserList;
///     final likedUsers = state.likedUserList;
///     final favorites = state.favoritesUserList;
///     final archived = state.archiveUserList;
///     final allUsers = state.allUserList;
///     // Use the lists as needed - all filtered locally!
///   }
/// )
/// ```
///
/// **The `profileList` property** contains the currently displayed list based on `selectedTabIndex`:
/// - Tab 0 (New): profileList = newUserList
/// - Tab 1 (Liked): profileList = likedUserList
/// - Tab 2 (Favorites): profileList = favoritesUserList
/// - Tab 3 (Archive): profileList = archiveUserList
/// - Tab 4 (All): profileList = allUserList
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
  final List<HomeModel?> newUserList;
  final List<HomeModel?> likedUserList;
  final List<HomeModel?> favoritesUserList;
  final List<HomeModel?> archiveUserList;
  final List<HomeModel?> allUserList;

  const HomeState({
    required this.data,
    required this.profileList,
    required this.selectedTabIndex,
    this.newUserList = const [],
    this.likedUserList = const [],
    this.favoritesUserList = const [],
    this.archiveUserList = const [],
    this.allUserList = const [],
  });

  HomeState copyWith({
    List<HomeModel?>? data,
    List<HomeModel?>? profileList,
    int? selectedTabIndex,
    List<HomeModel?>? newUserList,
    List<HomeModel?>? likedUserList,
    List<HomeModel?>? favoritesUserList,
    List<HomeModel?>? archiveUserList,
    List<HomeModel?>? allUserList,
  }) =>
      HomeState(
        data: data ?? this.data,
        profileList: profileList ?? this.profileList,
        selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
        newUserList: newUserList ?? this.newUserList,
        likedUserList: likedUserList ?? this.likedUserList,
        favoritesUserList: favoritesUserList ?? this.favoritesUserList,
        archiveUserList: archiveUserList ?? this.archiveUserList,
        allUserList: allUserList ?? this.allUserList,
      );

  factory HomeState.initial() {
    return HomeState(
      data: [],
      profileList: [],
      selectedTabIndex: 0,
      newUserList: [],
      likedUserList: [],
      favoritesUserList: [],
      archiveUserList: [],
      allUserList: [],
    );
  }

  @override
  List<Object> get props => [
        data,
        profileList,
        selectedTabIndex,
        newUserList,
        likedUserList,
        favoritesUserList,
        archiveUserList,
        allUserList
      ];
}

final class HomeInitial extends HomeState {
  HomeInitial()
      : super(
          data: [],
          profileList: [],
          selectedTabIndex: 0,
          newUserList: [],
          likedUserList: [],
          favoritesUserList: [],
          archiveUserList: [],
          allUserList: [],
        );
}

final class Loading extends HomeState {
  Loading.fromState(HomeState state)
      : super(
          data: state.data,
          profileList: state.profileList,
          selectedTabIndex: state.selectedTabIndex,
          newUserList: state.newUserList,
          likedUserList: state.likedUserList,
          favoritesUserList: state.favoritesUserList,
          archiveUserList: state.archiveUserList,
          allUserList: state.allUserList,
        );
}

final class Error extends HomeState {
  final String error;
  Error.fromState(HomeState state, {required this.error})
      : super(
          data: state.data,
          profileList: state.profileList,
          selectedTabIndex: state.selectedTabIndex,
          newUserList: state.newUserList,
          likedUserList: state.likedUserList,
          favoritesUserList: state.favoritesUserList,
          archiveUserList: state.archiveUserList,
          allUserList: state.allUserList,
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
          newUserList: state.newUserList,
          likedUserList: state.likedUserList,
          favoritesUserList: state.favoritesUserList,
          archiveUserList: state.archiveUserList,
          allUserList: state.allUserList,
        );
}
