import 'package:afriqueen/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:afriqueen/core/connectivity/bloc/connectivity_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper class for checking connectivity status throughout the app
class ConnectivityHelper {
  /// Check if the device is currently connected to the internet
  static bool isConnected(BuildContext context) {
    final state = context.read<ConnectivityBloc>().state;
    return state is ConnectivityOnline;
  }

  /// Show a snackbar when trying to perform an action without internet
  static void showNoInternetSnackbar(BuildContext context, {String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message ?? 'No internet connection. Please check your network.',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Execute an action only if connected, otherwise show a message
  static Future<T?> executeIfConnected<T>(
    BuildContext context, {
    required Future<T> Function() action,
    String? noInternetMessage,
  }) async {
    if (isConnected(context)) {
      return await action();
    } else {
      showNoInternetSnackbar(context, message: noInternetMessage);
      return null;
    }
  }
}
