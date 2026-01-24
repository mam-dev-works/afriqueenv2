# Connectivity Monitoring Guide

## Overview

This app now includes real-time internet connectivity monitoring using the BLoC pattern. The system automatically detects when your device loses or regains internet connection and notifies users with a persistent banner.

## Features

✅ **Real-time monitoring** - Continuously monitors network status  
✅ **Firebase connectivity check** - Verifies both internet and Firebase accessibility  
✅ **Visual feedback** - Shows a red banner when offline  
✅ **Retry functionality** - Users can manually retry connection check  
✅ **BLoC architecture** - Properly implemented using flutter_bloc  
✅ **Helper utilities** - Easy-to-use helpers for checking connectivity

## Architecture

```
lib/core/connectivity/
├── bloc/
│   ├── connectivity_bloc.dart      # Main BLoC logic
│   ├── connectivity_event.dart     # Events (start monitoring, status change, check)
│   └── connectivity_state.dart     # States (initial, online, offline, checking)
├── repository/
│   └── connectivity_repository.dart # Network monitoring implementation
├── widgets/
│   └── no_internet_banner.dart     # UI banner component
├── helpers/
│   └── connectivity_helper.dart    # Helper methods for connectivity checks
└── connectivity.dart               # Barrel export file
```

## Implementation Details

### 1. ConnectivityRepository

Located at `lib/core/connectivity/repository/connectivity_repository.dart`

**Key Features:**
- Uses `connectivity_plus` package to monitor network changes
- Performs DNS lookup to verify actual internet access
- Checks both `google.com` and `firestore.googleapis.com` accessibility
- Returns a stream of connectivity status updates

**Methods:**
- `checkConnectivity()` - Returns current connectivity status
- `connectivityStream` - Stream of connectivity changes

### 2. ConnectivityBloc

Located at `lib/core/connectivity/bloc/connectivity_bloc.dart`

**Events:**
- `ConnectivityStartMonitoring` - Initializes connectivity monitoring
- `ConnectivityStatusChanged` - Triggered when connectivity changes
- `ConnectivityCheckStatus` - Manually check current status

**States:**
- `ConnectivityInitial` - Initial state before monitoring starts
- `ConnectivityOnline` - Device has internet access
- `ConnectivityOffline` - No internet connection detected
- `ConnectivityChecking` - Currently verifying connection

### 3. NoInternetBanner Widget

Located at `lib/core/connectivity/widgets/no_internet_banner.dart`

**Features:**
- Displays at the top of the screen when offline
- Red banner with "No Internet Connection" message
- Retry button to manually check connection
- Orange "Checking..." state during verification
- Automatically disappears when connection is restored

### 4. ConnectivityHelper

Located at `lib/core/connectivity/helpers/connectivity_helper.dart`

**Utility Methods:**

```dart
// Check if device is connected
bool isConnected = ConnectivityHelper.isConnected(context);

// Show snackbar for no internet
ConnectivityHelper.showNoInternetSnackbar(context);

// Execute action only if connected
await ConnectivityHelper.executeIfConnected(
  context,
  action: () async {
    // Your code here
    return await someNetworkCall();
  },
  noInternetMessage: 'Cannot send message without internet',
);
```

## Integration in App

The connectivity monitoring is integrated in `lib/app.dart`:

```dart
return BlocProvider(
  create: (context) => ConnectivityBloc()
    ..add(const ConnectivityStartMonitoring()),
  child: ScreenUtilInit(
    // ... other code
    builder: (_, __) => GetMaterialApp(
      builder: (context, child) {
        return Column(
          children: [
            const NoInternetBanner(),  // <-- Banner shown here
            Expanded(child: child ?? const SizedBox()),
          ],
        );
      },
      // ... rest of app
    ),
  ),
);
```

## Usage Examples

### 1. Basic Usage - Already Integrated

The banner automatically appears when there's no internet. No additional code needed!

### 2. Check Connectivity Before Action

```dart
import 'package:afriqueen/core/connectivity/helpers/connectivity_helper.dart';

// In your widget
void sendMessage() async {
  await ConnectivityHelper.executeIfConnected(
    context,
    action: () async {
      // This code only runs if connected
      await chatRepository.sendMessage(message);
    },
    noInternetMessage: 'Cannot send message. Please check your connection.',
  );
}
```

### 3. React to Connectivity Changes in Widget

```dart
import 'package:afriqueen/core/connectivity/connectivity.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        if (state is ConnectivityOffline) {
          return Center(
            child: Text('You are offline'),
          );
        }
        
        return YourNormalWidget();
      },
    );
  }
}
```

### 4. Disable UI Elements When Offline

```dart
import 'package:afriqueen/core/connectivity/connectivity.dart';

ElevatedButton(
  onPressed: ConnectivityHelper.isConnected(context)
    ? () => doSomething()
    : null,  // Disabled when offline
  child: Text('Send'),
)
```

## Testing

### Test Scenarios:

1. **Turn off WiFi/Mobile Data**
   - Banner should appear immediately
   - Banner should be red with "No Internet Connection"

2. **Turn on WiFi/Mobile Data**
   - Banner should disappear automatically
   - App should reconnect to Firebase

3. **Weak Connection**
   - System verifies actual connectivity by DNS lookup
   - Won't show "online" if DNS fails

4. **Click Retry Button**
   - Shows orange "Checking..." state
   - Updates to online/offline based on result

## Troubleshooting

### Banner Not Showing
- Ensure `BlocProvider` is wrapping your app
- Check that `ConnectivityStartMonitoring` event is dispatched
- Verify `NoInternetBanner` is in the widget tree

### False Positives
- The system checks actual internet by DNS lookup
- Requires both WiFi connection AND working DNS
- Checks both Google and Firebase accessibility

### Performance
- Monitoring runs in background with minimal overhead
- Uses stream-based approach for efficiency
- Automatically cancels subscriptions when BLoC is closed

## Dependencies

```yaml
dependencies:
  connectivity_plus: ^6.1.0  # Network monitoring
  flutter_bloc: ^9.1.1       # State management
```

## Firebase-Specific Features

The connectivity check specifically verifies:
- General internet (via google.com)
- Firebase accessibility (via firestore.googleapis.com)

This ensures users are notified if:
- They have no internet at all
- Firebase services are blocked/unavailable

## Best Practices

1. **Use Helper Methods** - Leverage `ConnectivityHelper` for consistent UX
2. **Show Meaningful Messages** - Customize messages based on action
3. **Graceful Degradation** - Disable features when offline instead of crashing
4. **Cache Data** - Consider caching data for offline use
5. **User Feedback** - Always inform users why an action failed

## Future Enhancements

Potential improvements:
- Offline data caching with Hive
- Queued actions that execute when online
- Different banners for different connection types (2G/3G/4G/5G/WiFi)
- Background sync when connection restored
- Network speed monitoring

---

**Last Updated:** January 24, 2026  
**Implemented in:** lib/core/connectivity/
