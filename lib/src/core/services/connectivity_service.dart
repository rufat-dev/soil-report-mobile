import 'dart:async';
import 'dart:io';
import 'package:soilreport/src/constants/urls.dart';
import 'package:soilreport/src/core/data/dio_provider.dart';
import 'package:soilreport/src/utils/in_memory_store.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ConnectivityService(dio: dio);
}

@Riverpod(keepAlive: true)
Stream<ConnectivityStatus?> connectivityStatusChanges(Ref ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.connectivityStatusChanges();
}

@Riverpod(keepAlive: true)
Future connectivityServiceInitializer(Ref ref) async {
  ref.read(connectivityStatusChangesProvider);
  final connectivityService = ref.read(connectivityServiceProvider);
  return await connectivityService.initialize();
}

class ConnectivityService {

  final _connectivityState = InMemoryStore<ConnectivityStatus?>(null);
  Stream<ConnectivityStatus?> connectivityStatusChanges() => _connectivityState.stream;
  ConnectivityStatus? get connectivityStatus => _connectivityState.value;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final Dio _dio; 
  static final Uri _apiHealthUri = Uri.parse(Urls.mainEndpoint);

  ConnectivityService({required Dio dio}) : _dio = dio;

  

  Future<ConnectivityStatus> internetConnectionCheck() async {
    final result = await _connectivity.checkConnectivity();
    if(result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
       return ConnectivityStatus.hasInternetConnection;
    }
    return ConnectivityStatus.disconnected;    
  }

  Future<ConnectivityStatus> tcpConnectionCheck() async {
    try {
      final socket = await Socket.connect(
        _apiHealthUri.host,
        _apiHealthUri.port,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      return ConnectivityStatus.hasServerConnection;
    } catch (_) {
      return ConnectivityStatus.hasInternetConnection;
    }
  }

  Future<ConnectivityStatus> serverConnectionCheck() async {
    try {
      final healthCheckDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 3),
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          contentType: _dio.options.contentType,
          headers: _dio.options.headers,
        ),
      );
      final response = await healthCheckDio.get(
        _apiHealthUri.toString(),
      );
      return response.statusCode != null &&
              response.statusCode! < 500 ? ConnectivityStatus.hasServerConnection : ConnectivityStatus.hasInternetConnection;
    } catch (e) {
      return ConnectivityStatus.hasInternetConnection;
    }
  }

  Future<void> initialize() async {
    await checkConnectivity();
    // _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
    //   (status) async => await checkConnectivity());
  }
  
  Future<void> checkConnectivity() async {
    try{
      final status = await _connectivity.checkConnectivity();
      if(status.contains(ConnectivityResult.mobile) || status.contains(ConnectivityResult.wifi) || status.contains(ConnectivityResult.vpn)){
        final serverStatus = await serverConnectionCheck();
        _connectivityState.value = serverStatus;
        return;
      }
      _connectivityState.value = ConnectivityStatus.disconnected;
      return;
    }catch (e) {
      final a = e;
      _connectivityState.value = ConnectivityStatus.disconnected;
      return;
    }
  }
  
}


enum ConnectivityStatus {
  disconnected,
  hasInternetConnection,
  hasServerConnection,
}