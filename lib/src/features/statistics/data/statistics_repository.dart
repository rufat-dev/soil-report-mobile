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
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    final list = _normalizeListResponse(data);
    final response = DeviceListResponse(
      items: list
          .whereType<Map>()
          .map((e) => DeviceResponse.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
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

  Future<DeviceTrendsDailyResponse?> getDeviceTrendsDaily(
    String deviceId, {
    int limit = 90,
    bool useCache = true,
  }) async {
    final url =
        '${Urls.mainEndpoint}${Urls.deviceTrendsDailyPath}?deviceId=${Uri.encodeQueryComponent(deviceId)}&limit=$limit';
    final cacheKey = 'statistics::trends-daily::v2::$deviceId::$limit';
    if (useCache) {
      final cachedRaw = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(minutes: 30),
      );
      if (cachedRaw != null) {
        return DeviceTrendsDailyResponse.fromJson(
          jsonDecode(cachedRaw) as Map<String, dynamic>,
        );
      }
    }
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    final response =
        DeviceTrendsDailyResponse.fromJson(Map<String, dynamic>.from(data as Map));
    await cache.write(cacheKey, response.toJson());
    return response;
  }

  Future<List<DeviceAnomalyResponse>> getDeviceAnomalies(
    String deviceId, {
    bool useCache = true,
  }) async {
    final url =
        '${Urls.mainEndpoint}${Urls.deviceAnomaliesPath}?deviceId=${Uri.encodeQueryComponent(deviceId)}';
    final cacheKey = 'statistics::anomalies::$deviceId';
    if (useCache) {
      final cachedRaw = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(minutes: 20),
      );
      if (cachedRaw != null) {
        final decoded = jsonDecode(cachedRaw);
        return _normalizeListResponse(decoded)
            .whereType<Map>()
            .map((e) => DeviceAnomalyResponse.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    final response = _normalizeListResponse(data)
        .whereType<Map>()
        .map((e) => DeviceAnomalyResponse.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    await cache.write(
      cacheKey,
      jsonEncode(response.map((e) => e.toJson()).toList()),
    );
    return response;
  }

  Future<List<OutOfRangeEventResponse>> getOutOfRangeEvents(
    String deviceId, {
    int limit = 200,
    bool useCache = true,
  }) async {
    final url =
        '${Urls.mainEndpoint}${Urls.deviceOutOfRangeEventsPath}?deviceId=${Uri.encodeQueryComponent(deviceId)}&limit=$limit';
    final cacheKey = 'statistics::out-of-range::$deviceId::$limit';
    if (useCache) {
      final cachedRaw = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(minutes: 20),
      );
      if (cachedRaw != null) {
        final decoded = jsonDecode(cachedRaw);
        return _normalizeListResponse(decoded)
            .whereType<Map>()
            .map((e) =>
                OutOfRangeEventResponse.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    final response = _normalizeListResponse(data)
        .whereType<Map>()
        .map((e) => OutOfRangeEventResponse.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    await cache.write(
      cacheKey,
      jsonEncode(response.map((e) => e.toJson()).toList()),
    );
    return response;
  }

  List<dynamic> _normalizeListResponse(dynamic response) {
    if (response is List) {
      return response;
    }
    if (response is Map<String, dynamic>) {
      final items = response['items'];
      if (items is List) {
        return items;
      }
    }
    return const <dynamic>[];
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

class DeviceTrendsDailyResponse {
  final List<DeviceTrendsDailyPoint> points;

  const DeviceTrendsDailyResponse({required this.points});

  factory DeviceTrendsDailyResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['points'];
    final points = raw is List
        ? raw
            .whereType<Map>()
            .map((e) => DeviceTrendsDailyPoint.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : const <DeviceTrendsDailyPoint>[];
    return DeviceTrendsDailyResponse(points: points);
  }

  Map<String, dynamic> toJson() => {
    'points': points.map((e) => e.toJson()).toList(),
  };
}

class DeviceTrendsDailyPoint {
  final DateTime? dayTs;
  final double? slopeTemperature;
  final double? slopeMoisture;
  final double? slopeConductivity;
  final double? slopePhValue;
  final String? temperatureDirection;
  final String? moistureDirection;
  final String? conductivityDirection;
  final String? phDirection;
  final DateTime? computedAt;

  const DeviceTrendsDailyPoint({
    this.dayTs,
    this.slopeTemperature,
    this.slopeMoisture,
    this.slopeConductivity,
    this.slopePhValue,
    this.temperatureDirection,
    this.moistureDirection,
    this.conductivityDirection,
    this.phDirection,
    this.computedAt,
  });

  factory DeviceTrendsDailyPoint.fromJson(Map<String, dynamic> json) {
    return DeviceTrendsDailyPoint(
      dayTs: DateTime.tryParse((json['day'] ?? '').toString()),
      slopeTemperature: _toDouble(json['slope_temperature']),
      slopeMoisture: _toDouble(json['slope_moisture']),
      slopeConductivity: _toDouble(json['slope_conductivity']),
      slopePhValue: _toDouble(json['slope_ph_value']),
      temperatureDirection: json['temperature_direction']?.toString(),
      moistureDirection: json['moisture_direction']?.toString(),
      conductivityDirection: json['conductivity_direction']?.toString(),
      phDirection: json['ph_direction']?.toString(),
      computedAt: DateTime.tryParse((json['computed_at'] ?? '').toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'day': dayTs?.toIso8601String(),
    'slope_temperature': slopeTemperature,
    'slope_moisture': slopeMoisture,
    'slope_conductivity': slopeConductivity,
    'slope_ph_value': slopePhValue,
    'temperature_direction': temperatureDirection,
    'moisture_direction': moistureDirection,
    'conductivity_direction': conductivityDirection,
    'ph_direction': phDirection,
    'computed_at': computedAt?.toIso8601String(),
  };
}

double? _toDouble(dynamic raw) {
  if (raw == null) return null;
  if (raw is num) return raw.toDouble();
  if (raw is String) return double.tryParse(raw);
  return double.tryParse(raw.toString());
}

class DeviceAnomalyResponse {
  final String? anomalyType;
  final DateTime? detectedAt;
  final double? score;
  final String? summary;

  const DeviceAnomalyResponse({
    this.anomalyType,
    this.detectedAt,
    this.score,
    this.summary,
  });

  factory DeviceAnomalyResponse.fromJson(Map<String, dynamic> json) {
    return DeviceAnomalyResponse(
      anomalyType: json['anomaly_type']?.toString(),
      detectedAt: DateTime.tryParse((json['detected_at'] ?? '').toString()),
      score: (json['score'] as num?)?.toDouble(),
      summary: json['summary']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'anomaly_type': anomalyType,
    'detected_at': detectedAt?.toIso8601String(),
    'score': score,
    'summary': summary,
  };
}

class OutOfRangeEventResponse {
  final String? metric;
  final DateTime? eventTs;
  final double? value;
  final double? lowerBound;
  final double? upperBound;

  const OutOfRangeEventResponse({
    this.metric,
    this.eventTs,
    this.value,
    this.lowerBound,
    this.upperBound,
  });

  factory OutOfRangeEventResponse.fromJson(Map<String, dynamic> json) {
    return OutOfRangeEventResponse(
      metric: json['metric']?.toString(),
      eventTs: DateTime.tryParse((json['event_ts'] ?? '').toString()),
      value: (json['value'] as num?)?.toDouble(),
      lowerBound: (json['lower_bound'] as num?)?.toDouble(),
      upperBound: (json['upper_bound'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'metric': metric,
    'event_ts': eventTs?.toIso8601String(),
    'value': value,
    'lower_bound': lowerBound,
    'upper_bound': upperBound,
  };
}
