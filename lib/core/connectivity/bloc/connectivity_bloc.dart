import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afriqueen/core/connectivity/bloc/connectivity_event.dart';
import 'package:afriqueen/core/connectivity/bloc/connectivity_state.dart';
import 'package:afriqueen/core/connectivity/repository/connectivity_repository.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityRepository _connectivityRepository;
  StreamSubscription<bool>? _connectivitySubscription;

  ConnectivityBloc({
    ConnectivityRepository? connectivityRepository,
  })  : _connectivityRepository =
            connectivityRepository ?? ConnectivityRepository(),
        super(const ConnectivityInitial()) {
    on<ConnectivityStartMonitoring>(_onStartMonitoring);
    on<ConnectivityStatusChanged>(_onStatusChanged);
    on<ConnectivityCheckStatus>(_onCheckStatus);
  }

  Future<void> _onStartMonitoring(
    ConnectivityStartMonitoring event,
    Emitter<ConnectivityState> emit,
  ) async {
    // Cancel any existing subscription
    await _connectivitySubscription?.cancel();

    // Check initial status
    final isConnected = await _connectivityRepository.checkConnectivity();
    emit(
        isConnected ? const ConnectivityOnline() : const ConnectivityOffline());

    // Start monitoring connectivity changes
    _connectivitySubscription =
        _connectivityRepository.connectivityStream.listen(
      (isConnected) {
        add(ConnectivityStatusChanged(isConnected));
      },
    );
  }

  void _onStatusChanged(
    ConnectivityStatusChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    if (event.isConnected) {
      emit(const ConnectivityOnline());
    } else {
      emit(const ConnectivityOffline());
    }
  }

  Future<void> _onCheckStatus(
    ConnectivityCheckStatus event,
    Emitter<ConnectivityState> emit,
  ) async {
    emit(const ConnectivityChecking());
    final isConnected = await _connectivityRepository.checkConnectivity();
    emit(
        isConnected ? const ConnectivityOnline() : const ConnectivityOffline());
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
