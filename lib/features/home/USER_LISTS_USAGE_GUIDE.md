# User Lists Usage Guide

## 🚀 Performance Optimization: Caching Strategy

**KEY CONCEPT:** All user data is fetched from Firebase **ONLY ONCE** and cached locally. All subsequent list filtering happens **locally** without additional Firebase queries.

### How It Works

1. **Initial Load**: `HomeUsersFetched` event fetches ALL users from Firebase once
2. **Caching**: All user data is stored in `state.data` 
3. **Local Filtering**: All tab switches filter from the cached data locally
4. **Performance**: Instant tab switching, reduced Firebase costs, better UX

```
Firebase (1 call) → Cache (state.data) → Local Filtering → All Lists
                      ↓
                  ┌────────────────────────┐
                  │  newProfileList          │ ← Filtered locally
                  │  likedProfileList        │ ← Filtered locally
                  │  favoritesProfileList    │ ← Filtered locally
                  │  archiveProfileList      │ ← Filtered locally
                  │  allProfileList          │ ← Filtered locally
                  └────────────────────────┘
```

## Overview
The `HomeState` now provides dedicated lists for different user categories that can be easily accessed throughout the application.

## Available Lists

### 1. `newProfileList` - New Users
- **Contains**: Users who are NOT in favorites, archives, or blocked
- **Filtering**: LOCAL filtering from cached data
- **Firebase Calls**: 0 (uses cache)
- **Tab Index**: 0
- **Label**: "New" / "Nouveau"

### 2. `likedProfileList` - Liked Users
- **Contains**: Users that the current user has liked
- **Filtering**: Fetches like IDs, then filters from cache locally
- **Firebase Calls**: 1 (only for like IDs, not user data)
- **Tab Index**: 1
- **Label**: "Liked" / "Liké"

### 3. `favoritesProfileList` - Favorite Users
- **Contains**: Users marked as favorites
- **Filtering**: Fetches favorite IDs, then filters from cache locally
- **Firebase Calls**: 1 (only for favorite IDs, not user data)
- **Tab Index**: 2
- **Label**: "Favorite" / "Favori"

### 4. `archiveProfileList` - Archived Users
- **Contains**: Users in archive
- **Filtering**: Fetches archive IDs, then filters from cache locally
- **Firebase Calls**: 1 (only for archive IDs, not user data)
- **Tab Index**: 3
- **Label**: "Archive"

### 5. `allProfileList` - All Users
- **Contains**: ALL users (except current user and blocked users)
- **Filtering**: LOCAL filtering from cached data
- **Firebase Calls**: 0 (uses cache)
- **Tab Index**: 4
- **Label**: "All" / "Tous"

## How to Access Lists

### Method 1: BlocBuilder (Reactive)
```dart
BlocBuilder<HomeBloc, HomeState>(
  builder: (context, state) {
    // Access any specific list
    final newUsers = state.newProfileList;
    final likedUsers = state.likedProfileList;
    final favorites = state.favoritesProfileList;
    final archived = state.archiveProfileList;
    final allUsers = state.allProfileList;
    
    // Use the lists as needed
    return ListView.builder(
      itemCount: newUsers.length,
      itemBuilder: (context, index) {
        final user = newUsers[index];
        return UserCard(user: user);
      },
    );
  },
)
```

### Method 2: BlocSelector (Optimized for Single List)
```dart
// Select only the list you need - prevents unnecessary rebuilds
BlocSelector<HomeBloc, HomeState, List<HomeModel?>>(
  selector: (state) => state.favoritesProfileList,
  builder: (context, favorites) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final user = favorites[index];
        return FavoriteCard(user: user);
      },
    );
  },
)
```

### Method 3: Direct Access (Read-only)
```dart
// In a function or event handler
final homeState = context.read<HomeBloc>().state;
final allUsers = homeState.allProfileList;
final likedCount = homeState.likedProfileList.length;
```

## Triggering List Updates

### Initial Cache Load (Do this ONCE on app start)
```dart
// Fetch ALL users from Firebase and cache them
context.read<HomeBloc>().add(HomeUsersFetched());
```

### Fetch New Users (Filtered Locally)
```dart
context.read<HomeBloc>().add(HomeUsersProfileList());
```

### Fetch Liked Users (Filtered Locally)
```dart
context.read<HomeBloc>().add(FetchLikedUsers());
```

### Fetch Favorite Users (Filtered Locally)
```dart
context.read<HomeBloc>().add(FetchFavoriteUsers());
```

### Fetch Archive Users (Filtered Locally)
```dart
context.read<HomeBloc>().add(FetchArchiveUsers());
```

### Fetch All Users (Filtered Locally)
```dart
context.read<HomeBloc>().add(FetchAllUsers());
```

### Refresh Cache (When needed)
```dart
// Re-fetch from Firebase to update cache
context.read<HomeBloc>().add(HomeUsersFetched());
```

## Example: Custom Widget Using Multiple Lists

```dart
class UserStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            Text('New Users: ${state.newProfileList.length}'),
            Text('Liked: ${state.likedProfileList.length}'),
            Text('Favorites: ${state.favoritesProfileList.length}'),
            Text('Archived: ${state.archiveProfileList.length}'),
            Text('Total Users: ${state.allProfileList.length}'),
          ],
        );
      },
    );
  }
}
```

## Example: Filtering Users by Name

```dart
BlocBuilder<HomeBloc, HomeState>(
  builder: (context, state) {
    // Filter the list by name
    final filteredUsers = state.allProfileList.where((user) {
      if (user == null) return false;
      final searchTerm = 'John';
      return user.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
             user.pseudo.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
    
    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        return UserCard(user: filteredUsers[index]);
      },
    );
  },
)
```

## Important Notes

1. **All lists exclude the current user** - You will never see yourself in any list
2. **Blocked users are filtered out** - Blocked users won't appear in any list
3. **The `profileList` property** - This contains the currently active list based on the selected tab
4. **Lists are cached in state** - Once fetched via `HomeUsersFetched`, data remains in `state.data`
5. **Null safety** - All lists are of type `List<HomeModel?>` to handle null values safely
6. **Local filtering is FAST** - Switching tabs is instant because filtering happens locally
7. **Refresh cache when needed** - Call `HomeUsersFetched()` again to refresh the cache from Firebase

## Performance Benefits

✅ **Single Firebase Query** - All users fetched only once  
✅ **Instant Tab Switching** - Local filtering is extremely fast  
✅ **Reduced Firebase Costs** - Minimal read operations  
✅ **Better UX** - No loading delays when switching tabs  
✅ **Offline Capable** - Lists work from cache even with poor connectivity  

## When to Refresh Cache

- **On app start**: Always call `HomeUsersFetched()` to populate cache
- **After long session**: Periodically refresh to get new users
- **User action**: Pull-to-refresh functionality
- **After adding/removing users**: When favorite/archive/like status changes significantly

## Tab Indices Reference

| Tab Index | List Name | Label (EN) | Label (FR) |
|-----------|-----------|------------|------------|
| 0 | newProfileList | New | Nouveau |
| 1 | likedProfileList | Liked | Liké |
| 2 | favoritesProfileList | Favorite | Favori |
| 3 | archiveProfileList | Archive | Archive |
| 4 | allProfileList | All | Tous |

## State Properties

- `data`: Raw data from Firestore (rarely used directly)
- `profileList`: Currently displayed list based on selectedTabIndex
- `selectedTabIndex`: Current tab (0-4)
- `newProfileList`: New users list
- `likedProfileList`: Liked users list
- `favoritesProfileList`: Favorites list
- `archiveProfileList`: Archive list
- `allProfileList`: All users list
