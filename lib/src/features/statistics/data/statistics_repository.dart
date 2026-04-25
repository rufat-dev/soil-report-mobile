import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:soilreport/src/constants/urls.dart';
import 'package:soilreport/src/core/caching/cache_database.dart';
import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:soilreport/src/core/data/dio_provider.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/features/authentication/data/authorized_service.dart';
import 'package:soilreport/src/features/statistics/domain/soil_statistic_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_repository.g.dart';

class StatisticsRepository extends AuthorizedService {
  StatisticsRepository(super.secureStorage, super.auth, super.cache, super.dio);

  Future<DeviceListResponse> getDevices({bool useCache = true}) async {
    final url = '${Urls.mainEndpoint}${Urls.devicesPath}';
    final cacheKey = 'statistics::devices';
    if (useCache) {
      final cachedRaw = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(hours: 2),
      );
      if (cachedRaw != null) {
        return DeviceListResponse.fromJson(
          jsonDecode(cachedRaw) as Map<String, dynamic>,
        );
      }
    }
    final data = await get<Map<String, dynamic>>(
      url,
      (json) => json,
      headers: const {"content-type": "application/json"},
    );
    final response = DeviceListResponse.fromJson(data);
    await cache.write(cacheKey, response.toJson());
    return response;
  }

  Future<DeviceStateLatestResponse?> getDeviceStateLatest(
    String deviceId, {
    bool useCache = true,
  }) async {
    final url =
        '${Urls.mainEndpoint}${Urls.deviceStateLatestPath}?deviceId=${Uri.encodeQueryComponent(deviceId)}';
    final cacheKey = 'statistics::state-latest::$deviceId';
    if (useCache) {
      final cachedRaw = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(minutes: 20),
      );
      if (cachedRaw != null) {
        return DeviceStateLatestResponse.fromJson(
          jsonDecode(cachedRaw) as Map<String, dynamic>,
        );
      }
    }
    final response = await get<DeviceStateLatestResponse>(
      url,
      (json) => DeviceStateLatestResponse.fromJson(json),
      headers: const {"content-type": "application/json"},
    );
    await cache.write(cacheKey, response.toJson());
    return response;
  }

  Future<DeviceTimeseriesHourlyResponse?> getDeviceTimeseriesHourly(
    String deviceId, {
    int limit = 24,
    bool useCache = true,
  }) async {
    final url =
        '${Urls.mainEndpoint}${Urls.deviceTimeseriesHourlyPath}?deviceId=${Uri.encodeQueryComponent(deviceId)}&limit=$limit';
    final cacheKey = 'statistics::timeseries-hourly::$deviceId::$limit';
    if (useCache) {
      final cachedRaw = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(minutes: 20),
      );
      if (cachedRaw != null) {
        return DeviceTimeseriesHourlyResponse.fromJson(
          jsonDecode(cachedRaw) as Map<String, dynamic>,
        );
      }
    }
    final response = await get<DeviceTimeseriesHourlyResponse>(
      url,
      (json) => DeviceTimeseriesHourlyResponse.fromJson(json),
      headers: const {"content-type": "application/json"},
    );
    await cache.write(cacheKey, response.toJson());
    return response;
  }
}

@Riverpod(keepAlive: true)
StatisticsRepository statisticsRepository(Ref ref) {
  final cache = ref.watch(cacheDatabaseProvider);
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final auth = ref.watch(authRepositoryProvider);
  return StatisticsRepository(secureStorage, auth, cache, dio);
}
