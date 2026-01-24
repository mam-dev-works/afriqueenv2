import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityRepository {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectivityStream => _connectivityController.stream;

  ConnectivityRepository() {
    _init();
  }

  void _init() {
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((result) async {
      final isConnected = await _checkInternetConnection(result);
      _connectivityController.add(isConnected);
    });
  }

  /// Check if device has internet connectivity
  Future<bool> checkConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return await _checkInternetConnection(connectivityResult);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }

  /// Verify actual internet connection by attempting to resolve a host
  Future<bool> _checkInternetConnection(List<ConnectivityResult> result) async {
    // If no connectivity type is detected, return false
    if (result.contains(ConnectivityResult.none)) {
      debugPrint('No network connection detected');
      return false;
    }

    // For web platform, assume connection is available if connectivity type is detected
    if (kIsWeb) {
      return !result.contains(ConnectivityResult.none);
    }

    // For mobile/desktop, verify actual internet connection
    try {
      // Try to resolve Google DNS and Firebase
      final results = await Future.wait([
        InternetAddress.lookup('google.com'),
        InternetAddress.lookup('firestore.googleapis.com'),
      ]);

      final googleAvailable = results[0].isNotEmpty && results[0][0].rawAddress.isNotEmpty;
      final firebaseAvailable = results[1].isNotEmpty && results[1][0].rawAddress.isNotEmpty;

      if (googleAvailable && firebaseAvailable) {
        debugPrint('Internet connection verified - Google & Firebase accessible');
        return true;
      } else if (googleAvailable) {
        debugPrint('Internet available but Firebase may be blocked');
        return true;
      } else {
        debugPrint('DNS resolution failed');
        return false;
      }
    } on SocketException catch (e) {
      debugPrint('Internet connection check failed: $e');
      return false;
    } catch (e) {
      debugPrint('Unexpected error during connectivity check: $e');
      return false;
    }
  }

  void dispose() {
    _connectivityController.close();
  }
}
