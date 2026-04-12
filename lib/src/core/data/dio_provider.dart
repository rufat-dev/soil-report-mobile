import 'package:soilreport/src/core/network/network_error_navigation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

/// DioException types that mean "no internet" (timeout or connection failure).
/// Covers: connection timeout, connection error (e.g. socket), send/receive timeout.
bool _isConnectionOrTimeoutError(DioExceptionType type) {
  switch (type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return true;
    default:
      return false;
  }
}

/// Shared Dio instance. All HTTP calls that should trigger auth-alert on
/// connection/timeout must use this instance (e.g. pass to [RestService]).
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final options = BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
    contentType: 'application/json',
  );
  final client = Dio(options);
  client.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) {
        if (_isConnectionOrTimeoutError(error.type)) {
          notifyInternalNetworkError();
        }
        handler.next(error);
      },
    ),
  );
  return client;
}


