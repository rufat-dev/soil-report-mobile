import 'package:soilreport/src/utils/extensions/async_value_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'base_state.dart';

mixin MockableControllerMixin<T> on BuildlessAutoDisposeNotifier<T> {
  /// Fully populated mock data for non-server development.
  T get mockState;

  /// Mock state with loading checkState, used by Skeletonizer for shimmer previews.
  T get mockLoadingState;

  /// Returns [mockLoadingState] while the real state is still loading,
  /// [mockState] when no real data has arrived yet (null checkState),
  /// and the real [state] once data is available.
  T get effectiveState {
    final s = state;
    if (s is BaseState) {
      final check = (s as BaseState).checkState;
      if (check != null && check.isLoading) return mockLoadingState;
      if (check.isNullOrLoading) return mockState;
    }
    return s;
  }

  /// Whether the effective state is in a loading condition (for Skeletonizer).
  bool get isEffectiveLoading {
    final s = state;
    if (s is BaseState) {
      return (s as BaseState).checkState.isNullOrLoading;
    }
    return false;
  }
}
