/// Connectivity monitoring package
///
/// This package provides real-time network connectivity monitoring
/// using the BLoC pattern.
///
/// Usage:
/// ```dart
/// // 1. Wrap your app with BlocProvider
/// BlocProvider(
///   create: (context) => ConnectivityBloc()..add(const ConnectivityStartMonitoring()),
///   child: YourApp(),
/// )
///
/// // 2. Add the NoInternetBanner widget to your UI
/// Column(
///   children: [
///     const NoInternetBanner(),
///     Expanded(child: YourContent()),
///   ],
/// )
///
/// // 3. Listen to connectivity state in your widgets
/// BlocBuilder<ConnectivityBloc, ConnectivityState>(
///   builder: (context, state) {
///     if (state is ConnectivityOffline) {
///       return Text('No Internet');
///     }
///     return YourWidget();
///   },
/// )
/// ```

export 'bloc/connectivity_bloc.dart';
export 'bloc/connectivity_event.dart';
export 'bloc/connectivity_state.dart';
export 'repository/connectivity_repository.dart';
export 'widgets/no_internet_banner.dart';
export 'helpers/connectivity_helper.dart';
