import 'dart:async';

import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/services/app_initializer.dart';
import 'package:soilreport/src/core/services/connectivity_service.dart';
import 'package:soilreport/src/exceptions/app_exception.dart';
import 'package:soilreport/src/features/authentication/domain/auth_alert_type.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_alert_screen_controller.g.dart';


@riverpod
class AuthAlertScreenController extends _$AuthAlertScreenController {

  @override
  AuthAlertScreenState build() {
    return AuthAlertScreenState();
  }


  void setAlertType(AuthAlertType alertType) => state = state.copyWith(alertType: alertType);
  String getAlertKey() {
    switch (state.alertType) {
      case AuthAlertType.networkError:
        return 'Auth.Alert.NetworkError';
      case AuthAlertType.internalNetworkError:
        return 'Auth.Alert.InternalNetworkError';
      case AuthAlertType.unknown:
        return 'Auth.Alert.Unknown';
      default:
        return 'Auth.Alert.Unknown';
    }
  }

  Future<bool> retry() async {
    final service = ref.read(connectivityServiceProvider);
    final connectivityStatus = service.connectivityStatus;
    if (connectivityStatus != ConnectivityStatus.hasServerConnection) {
      state = state.copyWith(checkState: const AsyncValue.loading());
      try {
        await service.checkConnectivity();
        final connectivityStatus = service.connectivityStatus;
        if(connectivityStatus == ConnectivityStatus.hasServerConnection) {
          ref.invalidate(appInitializerProvider);
          await ref.read(appInitializerProvider.future);
          state = state.copyWith(checkState: const AsyncValue.data(null));
          return true;
        }else{
          state = state.copyWith(checkState: AsyncValue.error(NoInternetConnectionException(), StackTrace.current));
          return false;
        }
      } on StateError catch (e) {
        state = state.copyWith(checkState: const AsyncValue.data(null));
        return true;
      }
    }else{
      try {
        ref.invalidate(appInitializerProvider);
        await ref.read(appInitializerProvider.future);
        state = state.copyWith(checkState: const AsyncValue.data(null));
        return true;
      } catch (e) {
        final a = e;
        state = state.copyWith(checkState: AsyncValue.error(NoInternetConnectionException(), StackTrace.current));
        return false;
      }
    }
  }
}


class AuthAlertScreenState{
  final AuthAlertType? alertType;
  final AsyncValue<void>? checkState;

  const AuthAlertScreenState({
    this.alertType,
    this.checkState,
  });

  AuthAlertScreenState copyWith({
    AuthAlertType? alertType,
    AsyncValue<String?>? checkState,
  }) {
    return AuthAlertScreenState(
      alertType: alertType ?? this.alertType,
      checkState: checkState ?? this.checkState,
    );
  }
}
