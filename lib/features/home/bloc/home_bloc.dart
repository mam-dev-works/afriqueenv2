import 'package:afriqueen/features/favorite/model/favorite_model.dart';
import 'package:afriqueen/features/favorite/repository/favorite_repository.dart';
import 'package:afriqueen/features/home/bloc/home_event.dart';
import 'package:afriqueen/features/home/bloc/home_state.dart';
import 'package:afriqueen/features/home/model/home_model.dart';
import 'package:afriqueen/features/home/repository/home_repository.dart';
import 'package:afriqueen/features/match/repository/like_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../archive/model/archive_model.dart';
import '../../archive/repository/archive_repository.dart';
import '../../blocked/model/blocked_model.dart';
import '../../blocked/repository/blocked_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository __repository;
  final FavoriteRepository _favoriteRepository = FavoriteRepository();
  final ArchiveRepository _archiveRepository = ArchiveRepository();
  final BlockedRepository _blockedRepository = BlockedRepository();
  final LikeRepository _likeRepository = LikeRepository();

  HomeBloc({required HomeRepository repo})
      : __repository = repo,
        super(HomeInitial()) {
    on<HomeUsersFetched>((event, emit) async {
      // Fetch ALL users from Firebase ONCE and cache in state.data
      print('HomeBloc: Fetching ALL users from Firebase (CACHED)...');

      try {
        emit(Loading.fromState(state));

        // Fetch all users from Firebase only once
        final List<HomeModel?> allUsersFromFirebase =
            await __repository.fetchAllExceptCurrentUser();

        // Additional safety check: Filter out current user
        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        List<HomeModel?> cachedData = allUsersFromFirebase;
        if (currentUserId != null && currentUserId.isNotEmpty) {
          cachedData = allUsersFromFirebase.where((item) {
            if (item == null) return false;
            final isCurrentUser = item.id == currentUserId || item.id.isEmpty;
            if (isCurrentUser) {
              print(
                  'HomeBloc: Excluding current user - User ID: ${item.id}, Current UID: $currentUserId');
            }
            return !isCurrentUser;
          }).toList();
        }

        if (cachedData.isEmpty) {
          emit(HomeDataIsEmpty.fromState(state));
        } else {
          // Store all users in state.data for local filtering
          print('HomeBloc: Cached ${cachedData.length} users locally');
          emit(state.copyWith(data: cachedData));
        }
      } catch (e) {
        // Handle "Bad state: No element" errors gracefully
        if (e.toString().contains('Bad state: No element')) {
          emit(HomeDataIsEmpty.fromState(state));
        } else {
          emit(Error.fromState(state, error: e.toString()));
        }
      }
    });
    on<HomeUsersProfileList>((event, emit) async {
      // Filter NEW users from cached data (local filtering - no Firebase call)
      print('HomeBloc: Filtering NEW users from cached data...');

      try {
        emit(Loading.fromState(state));

        // Use cached data from state.data (already fetched from Firebase)
        List<HomeModel?> cachedData = state.data;

        // If cache is empty, fetch from Firebase first
        if (cachedData.isEmpty) {
          print('HomeBloc: Cache empty, fetching from Firebase...');
          cachedData = await __repository.fetchAllExceptCurrentUser();

          // Filter out current user
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          if (currentUserId != null && currentUserId.isNotEmpty) {
            cachedData = cachedData.where((item) {
              if (item == null) return false;
              return item.id != currentUserId && item.id.isNotEmpty;
            }).toList();
          }
        }

        if (cachedData.isEmpty) {
          emit(HomeDataIsEmpty.fromState(state));
          return;
        }

        // Fetch favorite, archive, and blocked IDs for local filtering
        final FavoriteModel? favData =
            await _favoriteRepository.fetchFavorites();
        final ArchiveModel? archiveData =
            await _archiveRepository.fetchArchives();
        final BlockedModel? blockedData =
            await _blockedRepository.fetchBlockedUsers();

        // Filter locally from cached data
        List<HomeModel?> newUserList = cachedData;

        if (favData != null) {
          newUserList = newUserList
              .where((item) =>
                  item!.id.isNotEmpty && !favData.favId.contains(item.id))
              .toList();
        }
        if (archiveData != null) {
          newUserList = newUserList
              .where((item) =>
                  item!.id.isNotEmpty &&
                  !archiveData.archiveId.contains(item.id))
              .toList();
        }
        if (blockedData != null) {
          newUserList = newUserList
              .where((item) =>
                  item!.id.isNotEmpty &&
                  !blockedData.blockedUserId.contains(item.id))
              .toList();
        }

        print('HomeBloc: Filtered ${newUserList.length} new users from cache');

        // Set selectedTabIndex to 0 for New tab
        emit(state.copyWith(
          data: cachedData, // Update cache if it was fetched
          profileList: newUserList,
          selectedTabIndex: 0,
          newUserList: newUserList, // Store in dedicated newUserList
        ));
      } catch (e) {
        print('HomeBloc Error: $e');
        // Handle "Bad state: No element" errors gracefully
        if (e.toString().contains('Bad state: No element')) {
          emit(HomeDataIsEmpty.fromState(state));
        } else {
          emit(Error.fromState(state, error: e.toString()));
        }
      }
    });

    on<FetchLikedUsers>((event, emit) async {
      print('HomeBloc: Filtering LIKED users from cached data...');
      try {
        emit(Loading.fromState(state));

        // Use cached data from state.data
        List<HomeModel?> cachedData = state.data;

        // If cache is empty, fetch from Firebase first
        if (cachedData.isEmpty) {
          print('HomeBloc: Cache empty, fetching from Firebase...');
          cachedData = await __repository.fetchAllExceptCurrentUser();

          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          if (currentUserId != null && currentUserId.isNotEmpty) {
            cachedData = cachedData.where((item) {
              if (item == null) return false;
              return item.id != currentUserId && item.id.isNotEmpty;
            }).toList();
          }
        }

        // Fetch liked user IDs (only IDs, not full user data)
        final likedUserIds = await _likeRepository.getLikedUserIds();

        if (likedUserIds.isNotEmpty) {
          // Filter liked users from cached data (local filtering)
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          final List<HomeModel?> likedProfiles = cachedData.where((user) {
            if (user == null) return false;
            if (currentUserId != null && user.id == currentUserId) return false;
            return likedUserIds.contains(user.id);
          }).toList();

          print(
              'HomeBloc: Filtered ${likedProfiles.length} liked users from cache');

          emit(state.copyWith(
            data: cachedData, // Update cache if it was fetched
            profileList: likedProfiles,
            selectedTabIndex: 1,
            likedUserList: likedProfiles,
          ));
        } else {
          emit(state.copyWith(
            data: cachedData,
            profileList: [],
            selectedTabIndex: 1,
            likedUserList: [],
          ));
        }
      } catch (e) {
        print('HomeBloc Error fetching liked users: $e');
        emit(Error.fromState(state, error: e.toString()));
      }
    });

    on<FetchFavoriteUsers>((event, emit) async {
      print('HomeBloc: Filtering FAVORITE users from cached data...');
      try {
        emit(Loading.fromState(state));

        // Use cached data from state.data
        List<HomeModel?> cachedData = state.data;

        // If cache is empty, fetch from Firebase first
        if (cachedData.isEmpty) {
          print('HomeBloc: Cache empty, fetching from Firebase...');
          cachedData = await __repository.fetchAllExceptCurrentUser();

          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          if (currentUserId != null && currentUserId.isNotEmpty) {
            cachedData = cachedData.where((item) {
              if (item == null) return false;
              return item.id != currentUserId && item.id.isNotEmpty;
            }).toList();
          }
        }

        // Fetch favorite user IDs (only IDs, not full user data)
        final favoriteUsers = await _favoriteRepository.fetchFavorites();

        if (favoriteUsers != null && favoriteUsers.favId.isNotEmpty) {
          // Filter favorite users from cached data (local filtering)
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          final List<HomeModel?> favoriteProfiles = cachedData.where((user) {
            if (user == null) return false;
            if (currentUserId != null && user.id == currentUserId) return false;
            return favoriteUsers.favId.contains(user.id);
          }).toList();

          print(
              'HomeBloc: Filtered ${favoriteProfiles.length} favorite users from cache');

          emit(state.copyWith(
            data: cachedData, // Update cache if it was fetched
            profileList: favoriteProfiles,
            selectedTabIndex: 2,
            favoritesUserList: favoriteProfiles,
          ));
        } else {
          emit(state.copyWith(
            data: cachedData,
            profileList: [],
            selectedTabIndex: 2,
            favoritesUserList: [],
          ));
        }
      } catch (e) {
        print('HomeBloc Error fetching favorite users: $e');
        emit(Error.fromState(state, error: e.toString()));
      }
    });

    on<FetchArchiveUsers>((event, emit) async {
      print('HomeBloc: Filtering ARCHIVE users from cached data...');
      try {
        emit(Loading.fromState(state));

        // Use cached data from state.data
        List<HomeModel?> cachedData = state.data;

        // If cache is empty, fetch from Firebase first
        if (cachedData.isEmpty) {
          print('HomeBloc: Cache empty, fetching from Firebase...');
          cachedData = await __repository.fetchAllExceptCurrentUser();

          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          if (currentUserId != null && currentUserId.isNotEmpty) {
            cachedData = cachedData.where((item) {
              if (item == null) return false;
              return item.id != currentUserId && item.id.isNotEmpty;
            }).toList();
          }
        }

        // Fetch archive user IDs (only IDs, not full user data)
        final archiveUsers = await _archiveRepository.fetchArchives();

        if (archiveUsers != null && archiveUsers.archiveId.isNotEmpty) {
          // Filter archive users from cached data (local filtering)
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          final List<HomeModel?> archiveProfiles = cachedData.where((user) {
            if (user == null) return false;
            if (currentUserId != null && user.id == currentUserId) return false;
            return archiveUsers.archiveId.contains(user.id);
          }).toList();

          print(
              'HomeBloc: Filtered ${archiveProfiles.length} archive users from cache');

          emit(state.copyWith(
            data: cachedData, // Update cache if it was fetched
            profileList: archiveProfiles,
            selectedTabIndex: 3,
            archiveUserList: archiveProfiles,
          ));
        } else {
          emit(state.copyWith(
            data: cachedData,
            profileList: [],
            selectedTabIndex: 3,
            archiveUserList: [],
          ));
        }
      } catch (e) {
        print('HomeBloc Error fetching archive users: $e');
        emit(Error.fromState(state, error: e.toString()));
      }
    });

    on<FetchAllUsers>((event, emit) async {
      print('HomeBloc: Filtering ALL users from cached data...');
      try {
        emit(Loading.fromState(state));

        // Use cached data from state.data
        List<HomeModel?> cachedData = state.data;

        // If cache is empty, fetch from Firebase first
        if (cachedData.isEmpty) {
          print('HomeBloc: Cache empty, fetching from Firebase...');
          cachedData = await __repository.fetchAllExceptCurrentUser();

          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          if (currentUserId != null && currentUserId.isNotEmpty) {
            cachedData = cachedData.where((item) {
              if (item == null) return false;
              return item.id != currentUserId && item.id.isNotEmpty;
            }).toList();
          }
        }

        // For "All" tab, show ALL users (only filter out blocked users locally)
        final BlockedModel? blockedData =
            await _blockedRepository.fetchBlockedUsers();

        List<HomeModel?> allUserList = cachedData;

        // Filter out blocked users locally
        if (blockedData != null) {
          allUserList = allUserList
              .where((item) =>
                  item!.id.isNotEmpty &&
                  !blockedData.blockedUserId.contains(item.id))
              .toList();
        }

        print(
            'HomeBloc: Filtered ${allUserList.length} total users from cache');

        if (allUserList.isEmpty) {
          emit(HomeDataIsEmpty.fromState(state));
        } else {
          emit(state.copyWith(
            data: cachedData, // Update cache if it was fetched
            profileList: allUserList,
            selectedTabIndex: 4,
            allUserList: allUserList,
          ));
        }
      } catch (e) {
        print('HomeBloc Error fetching all users: $e');
        // Handle "Bad state: No element" errors gracefully
        if (e.toString().contains('Bad state: No element')) {
          emit(HomeDataIsEmpty.fromState(state));
        } else {
          emit(Error.fromState(state, error: e.toString()));
        }
      }
    });
  }
}
