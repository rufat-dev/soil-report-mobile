import 'package:soilreport/src/core/services/preflight_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

mixin AppActionGuard<TState> on AutoDisposeNotifier<TState> {

  /// Update state.checkState (you implement this per-state, or unify states later).
  TState setCheckState(TState s, AsyncValue<void>? v);

  Future<T> runGuarded<T>(Future<T> Function() action,) async {
    // 1) show loading
    state = setCheckState(state, const AsyncValue.loading());

    // 2) run global preflight (throws if fails)
    final preflight = ref.read(preflightProvider);
    try {
      await preflight();
    } catch (e, st) {
      state = setCheckState(state, AsyncValue.error(e, st));
      rethrow;    
    }
    try {
      final value = await action();
      state = setCheckState(state, const AsyncValue.data(null));
      return value;
    } catch (e, st) {
      state = setCheckState(state, AsyncValue.error(e, st));
      Error.throwWithStackTrace(e, st);
    }
  }
}