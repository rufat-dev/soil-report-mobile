import 'package:soilreport/src/core/services/connectivity_service.dart';
import 'package:soilreport/src/exceptions/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PreflightFn = Future<void> Function();

final preflightProvider = Provider<PreflightFn>((ref) {
  return () async {
    final enabled = await ref.read(connectivityServiceProvider).internetConnectionCheck();
    if (enabled == ConnectivityStatus.disconnected) {
      throw NoInternetConnectionException();
    }
    final serverStatus = await ref.read(connectivityServiceProvider).serverConnectionCheck();
    if (serverStatus != ConnectivityStatus.hasServerConnection) {
      throw CantReachServerException(); 
    }
  };
});