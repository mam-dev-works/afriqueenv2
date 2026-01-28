import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

/// Global BLoC observer to help debug events, state changes and errors.
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    debugPrint('[BLOC] ${bloc.runtimeType} event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    debugPrint('[BLOC] ${bloc.runtimeType} change: $change');
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('[BLOC] ${bloc.runtimeType} error: $error');
    debugPrint(stackTrace.toString());
    super.onError(bloc, error, stackTrace);
  }
}
