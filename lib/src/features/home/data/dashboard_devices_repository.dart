import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soilreport/src/constants/urls.dart';
import 'package:soilreport/src/core/caching/cache_database.dart';
import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:soilreport/src/core/data/dio_provider.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/features/authentication/data/authorized_service.dart';
import 'package:soilreport/src/features/home/domain/dashboard_device_model.dart';

part 'dashboard_devices_repository.g.dart';

class DashboardDevicesRepository extends AuthorizedService {
  DashboardDevicesRepository(
    super.secureStorage,
    super.auth,
    super.cache,
    super.dio,
  );

  Future<List<DashboardDeviceModel>> getDevices({bool useCache = true}) async {
    final url = '${Urls.mainEndpoint}${Urls.devicesPath}';
    final cacheKey = 'dashboard::devices::$url';
    if (useCache) {
      final cached = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(minutes: 20),
      );
      if (cached != null) {
        return _parseDevicesList(jsonDecode(cached));
      }
    }
    try{
      
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    final devices = _parseDevicesList(data);
    await cache.write(
      cacheKey,
      jsonEncode(devices.map((e) => e.toJson()).toList()),
    );
    return devices;
    } catch (_) {
      return [];
    }
  }

  Future<List<DeviceGroupModel>> getGroups({bool useCache = true}) async {
    final url = '${Urls.mainEndpoint}${Urls.groupsPath}';
    final cacheKey = 'dashboard::groups::$url';
    if (useCache) {
      final cached = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(minutes: 20),
      );
      if (cached != null) {
        return _parseGroupsList(jsonDecode(cached));
      }
    }
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    final groups = _parseGroupsList(data);
    await cache.write(
      cacheKey,
      jsonEncode(groups.map((e) => e.toJson()).toList()),
    );
    return groups;
  }

  Future<List<PlantClassifierModel>> getPlants({bool useCache = true}) async {
    final url = '${Urls.mainEndpoint}${Urls.classifierPlantsPath}';
    final cacheKey = 'dashboard::plants::$url';
    if (useCache) {
      final cached = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(hours: 12),
      );
      if (cached != null) {
        return _parsePlantsList(jsonDecode(cached));
      }
    }
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    final plants = _parsePlantsList(data);
    await cache.write(
      cacheKey,
      jsonEncode(plants.map((e) => e.toJson()).toList()),
    );
    return plants;
  }

  Future<List<SoilClassifierModel>> getSoils({bool useCache = true}) async {
    final url = '${Urls.mainEndpoint}${Urls.classifierSoilsPath}';
    final cacheKey = 'dashboard::soils::$url';
    if (useCache) {
      final cached = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(hours: 12),
      );
      if (cached != null) {
        return _parseSoilsList(jsonDecode(cached));
      }
    }
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    final soils = _parseSoilsList(data);
    await cache.write(
      cacheKey,
      jsonEncode(soils.map((e) => e.toJson()).toList()),
    );
    return soils;
  }

  Future<List<OperationStatusClassifierModel>> getOperationStatuses({
    bool useCache = true,
  }) async {
    final url = '${Urls.mainEndpoint}${Urls.classifierOperationStatusesPath}';
    final cacheKey = 'dashboard::operation-statuses::$url';
    if (useCache) {
      final cached = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(hours: 12),
      );
      if (cached != null) {
        return _parseOperationStatusesList(jsonDecode(cached));
      }
    }
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    final statuses = _parseOperationStatusesList(data);
    await cache.write(
      cacheKey,
      jsonEncode(statuses.map((e) => e.toJson()).toList()),
    );
    return statuses;
  }

  Future<DeviceGroupModel> createGroup(GroupCreatePayload payload) async {
    final url = '${Urls.mainEndpoint}${Urls.groupsPath}';
    final created = await postWithPayload<DeviceGroupModel>(
      url,
      (json) =>
          DeviceGroupModel.fromJson(Map<String, dynamic>.from(json as Map)),
      payload.toJson(),
    );
    return created;
  }

  Future<DashboardDeviceModel> getDeviceByPathId(String deviceId) async {
    final url =
        '${Urls.mainEndpoint}${Urls.devicesPath}/${Uri.encodeComponent(deviceId)}';
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    return DashboardDeviceModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<DashboardDeviceModel> getDeviceByQueryId(String deviceId) async {
    final url =
        '${Urls.mainEndpoint}${Urls.devicePath}?deviceId=${Uri.encodeQueryComponent(deviceId)}';
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    return DashboardDeviceModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<DashboardDeviceModel> updateDevice(
    String deviceId,
    Map<String, dynamic> payload,
  ) async {
    final url =
        '${Urls.mainEndpoint}${Urls.devicesPath}/${Uri.encodeComponent(deviceId)}';
    final updated = await putWithPayload<DashboardDeviceModel>(
      url,
      (json) =>
          DashboardDeviceModel.fromJson(Map<String, dynamic>.from(json as Map)),
      payload,
    );
    return updated;
  }

  Future<DashboardDeviceModel> createDevice(DeviceCreatePayload payload) async {
    final url = '${Urls.mainEndpoint}${Urls.devicesPath}';
    final created = await postWithPayload<DashboardDeviceModel>(
      url,
      (json) =>
          DashboardDeviceModel.fromJson(Map<String, dynamic>.from(json as Map)),
      payload.toJson(),
    );
    return created;
  }

  Future<DeviceGroupModel> getGroupById(String groupId) async {
    final url =
        '${Urls.mainEndpoint}${Urls.groupsPath}/${Uri.encodeComponent(groupId)}';
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    return DeviceGroupModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<DeviceGroupModel> updateGroup(
    String groupId,
    Map<String, dynamic> payload,
  ) async {
    final url =
        '${Urls.mainEndpoint}${Urls.groupsPath}/${Uri.encodeComponent(groupId)}';
    final updated = await putWithPayload<DeviceGroupModel>(
      url,
      (json) =>
          DeviceGroupModel.fromJson(Map<String, dynamic>.from(json as Map)),
      payload,
    );
    return updated;
  }

  List<DashboardDeviceModel> _parseDevicesList(dynamic response) {
    final rawList = _normalizeListResponse(response);
    return rawList
        .whereType<Map>()
        .map((e) => DashboardDeviceModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  List<DeviceGroupModel> _parseGroupsList(dynamic response) {
    final rawList = _normalizeListResponse(response);
    return rawList
        .whereType<Map>()
        .map((e) => DeviceGroupModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  List<PlantClassifierModel> _parsePlantsList(dynamic response) {
    final rawList = _normalizeListResponse(response);
    return rawList
        .whereType<Map>()
        .map((e) => PlantClassifierModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  List<SoilClassifierModel> _parseSoilsList(dynamic response) {
    final rawList = _normalizeListResponse(response);
    return rawList
        .whereType<Map>()
        .map((e) => SoilClassifierModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  List<OperationStatusClassifierModel> _parseOperationStatusesList(
    dynamic response,
  ) {
    final rawList = _normalizeListResponse(response);
    return rawList
        .whereType<Map>()
        .map(
          (e) => OperationStatusClassifierModel.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
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
DashboardDevicesRepository dashboardDevicesRepository(Ref ref) {
  final cache = ref.watch(cacheDatabaseProvider);
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final auth = ref.watch(authRepositoryProvider);
  return DashboardDevicesRepository(secureStorage, auth, cache, dio);
}
