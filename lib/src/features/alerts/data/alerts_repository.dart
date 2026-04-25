import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soilreport/src/constants/urls.dart';
import 'package:soilreport/src/core/caching/cache_database.dart';
import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:soilreport/src/core/data/dio_provider.dart';
import 'package:soilreport/src/features/alerts/domain/soil_alert_model.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/features/authentication/data/authorized_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alerts_repository.g.dart';

class AlertsRepository extends AuthorizedService {
  AlertsRepository(super.secureStorage, super.auth, super.cache, super.dio);

  /// SoilReportFn returns a JSON array of alert objects.
  Future<List<AlertItemResponse>> listAlerts({
    String? deviceId,
    String? deviceGroupId,
    bool unreadOnly = false,
    int? limit,
    int? offset,
    bool useCache = true,
  }) async {
    final query = <String, String>{
      if (deviceId != null && deviceId.isNotEmpty) 'deviceId': deviceId,
      if (deviceGroupId != null && deviceGroupId.isNotEmpty)
        'deviceGroupId': deviceGroupId,
      if (unreadOnly) 'unreadOnly': 'true',
      if (limit != null) 'limit': '$limit',
      if (offset != null) 'offset': '$offset',
    };
    final querySuffix = query.isEmpty
        ? ''
        : '?${query.entries.map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}').join('&')}';
    final url = '${Urls.mainEndpoint}${Urls.alertsPath}$querySuffix';
    final cacheKey = 'alerts::v2::$url';

    if (useCache) {
      final cachedRaw = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(minutes: 5),
      );
      if (cachedRaw != null) {
        final decoded = jsonDecode(cachedRaw);
        return _parseAlertList(decoded);
      }
    }

    final data = await rawGetDynamic(
      url,
      headers: const {'content-type': 'application/json'},
    );
    final list = _parseAlertList(data);
    await cache.write(cacheKey, jsonEncode(list.map((e) => e.toJson()).toList()));
    return list;
  }

  static List<AlertItemResponse> _parseAlertList(dynamic data) {
    if (data is List) {
      return data
          .map(
            (e) => AlertItemResponse.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    }
    if (data is Map<String, dynamic> && data['items'] is List) {
      return (data['items'] as List)
          .map(
            (e) => AlertItemResponse.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    }
    return const [];
  }

  Future<AlertItemResponse?> updateAlert(
    String alertId,
    AlertUpdateRequest payload,
  ) async {
    final data = await putWithPayload<AlertItemResponse>(
      '${Urls.mainEndpoint}${Urls.alertsPath}/$alertId',
      (json) =>
          AlertItemResponse.fromJson(Map<String, dynamic>.from(json as Map)),
      payload.toJson(),
    );
    return data;
  }

  Future<AlertItemResponse?> getAlert(String alertId) async {
    final data = await rawGetDynamic(
      '${Urls.mainEndpoint}${Urls.alertsPath}/$alertId',
      headers: const {'content-type': 'application/json'},
    );
    return AlertItemResponse.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<AlertItemResponse?> createAlert(AlertCreateRequest payload) async {
    final data = await postWithPayload<AlertItemResponse>(
      '${Urls.mainEndpoint}${Urls.alertsPath}',
      (json) =>
          AlertItemResponse.fromJson(Map<String, dynamic>.from(json as Map)),
      payload.toJson(),
    );
    return data;
  }

  Future<void> deleteAlert(String alertId) async {
    final url = '${Urls.mainEndpoint}${Urls.alertsPath}/$alertId';
    await rawDelete(url, headers: const {'content-type': 'application/json'});
  }
}

@Riverpod(keepAlive: true)
AlertsRepository alertsRepository(Ref ref) {
  final cache = ref.watch(cacheDatabaseProvider);
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final auth = ref.watch(authRepositoryProvider);
  return AlertsRepository(secureStorage, auth, cache, dio);
}
