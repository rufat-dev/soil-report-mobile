import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/home/data/dashboard_devices_repository.dart';
import 'package:soilreport/src/features/home/domain/dashboard_device_model.dart';
import 'package:soilreport/src/features/statistics/data/statistics_repository.dart';
import 'package:soilreport/src/features/statistics/domain/soil_statistic_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_screen_controller.g.dart';

@riverpod
class DashboardScreenController extends _$DashboardScreenController
    with MockableControllerMixin<DashboardScreenState> {
  @override
  DashboardScreenState build() {
    ref.keepAlive();
    return DashboardScreenState(
      checkState: null,
      stories: [],
      bannerImage: null,
      bannerLink: null,
      isRealScope: false,
      devices: const [],
      groups: const [],
      operationStatuses: const [],
      latestStateByDeviceId: const {},
      attentionDeviceIds: const [],
    );
  }

  @override
  DashboardScreenState get mockState => DashboardScreenState(
    checkState: const AsyncValue.data(null),
    stories: const [],
    bannerImage: '',
    bannerLink: '',
        isRealScope: true,
        devices: const [],
        groups: const [],
        operationStatuses: const [],
        latestStateByDeviceId: const {},
        attentionDeviceIds: const [],
      );

  @override
  DashboardScreenState get mockLoadingState => DashboardScreenState(
    checkState: const AsyncValue.loading(),
    stories: const [],
    bannerImage: null,
    bannerLink: null,
        isRealScope: false,
        devices: const [],
        groups: const [],
        operationStatuses: const [],
        latestStateByDeviceId: const {},
        attentionDeviceIds: const [],
      );

  Future<void> loadScreen({bool useCache = true}) async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    final devicesRepo = ref.read(dashboardDevicesRepositoryProvider);
    final statisticsRepo = ref.read(statisticsRepositoryProvider);
    try {
      final results = await Future.wait([
        devicesRepo.getDevices(useCache: useCache),
        devicesRepo.getGroups(useCache: useCache),
        devicesRepo.getOperationStatuses(useCache: useCache),
      ]);
      final devices = results[0] as List<DashboardDeviceModel>;
      final operationStatuses = results[2] as List<OperationStatusClassifierModel>;

      final latestEntries = await Future.wait(
        devices.map((d) async {
          try {
            final latest = await statisticsRepo.getDeviceStateLatest(
              d.deviceId,
              useCache: useCache,
            );
            return MapEntry(d.deviceId, latest);
          } catch (_) {
            return MapEntry<String, DeviceStateLatestResponse?>(d.deviceId, null);
          }
        }),
      );
      final latestStateByDeviceId = <String, DeviceStateLatestResponse>{};
      for (final e in latestEntries) {
        if (e.value != null) {
          latestStateByDeviceId[e.key] = e.value!;
        }
      }

      final attentionDeviceIds = devices
          .where(
            (d) => _needsAttention(
              device: d,
              latest: latestStateByDeviceId[d.deviceId],
            ),
          )
          .map((d) => d.deviceId)
          .toList(growable: false);

      state = state.copyWith(
        checkState: const AsyncValue.data(null),
        isRealScope: true,
        devices: devices,
        groups: results[1] as List<DeviceGroupModel>,
        operationStatuses: operationStatuses,
        latestStateByDeviceId: latestStateByDeviceId,
        attentionDeviceIds: attentionDeviceIds,
      );
    } catch (_) {
      state = state.copyWith(
        checkState: const AsyncValue.data(null),
        isRealScope: true,
      );
    }
  }

  bool _needsAttention({
    required DashboardDeviceModel device,
    required DeviceStateLatestResponse? latest,
  }) {
    if (device.operationalStatus == 3) return true;

    if (latest == null) return false;
    final moisture = latest.moisture;
    final ph = latest.phValue;
    final conductivity = latest.conductivity;
    if (moisture != null && (moisture < 20 || moisture > 70)) return true;
    if (ph != null && (ph < 5.5 || ph > 8.0)) return true;
    if (conductivity != null && (conductivity < 200 || conductivity > 2500)) {
      return true;
    }
    return false;
  }
}

class DashboardScreenState extends BaseState {
  final List<Object> stories;
  final String? bannerImage;
  final String? bannerLink;
  final bool isRealScope;
  final List<DashboardDeviceModel> devices;
  final List<DeviceGroupModel> groups;
  final List<OperationStatusClassifierModel> operationStatuses;
  final Map<String, DeviceStateLatestResponse> latestStateByDeviceId;
  final List<String> attentionDeviceIds;

  const DashboardScreenState({
    super.checkState,
    required this.stories,
    this.bannerImage,
    this.bannerLink,
    required this.isRealScope,
    required this.devices,
    required this.groups,
    required this.operationStatuses,
    required this.latestStateByDeviceId,
    required this.attentionDeviceIds,
  });

  DashboardScreenState copyWith({
    AsyncValue<String?>? checkState,
    List<Object>? stories,
    String? bannerImage,
    String? bannerLink,
    bool? isRealScope,
    List<DashboardDeviceModel>? devices,
    List<DeviceGroupModel>? groups,
    List<OperationStatusClassifierModel>? operationStatuses,
    Map<String, DeviceStateLatestResponse>? latestStateByDeviceId,
    List<String>? attentionDeviceIds,
  }) {
    return DashboardScreenState(
      checkState: checkState ?? this.checkState,
      stories: stories ?? this.stories,
      bannerImage: bannerImage ?? this.bannerImage,
      bannerLink: bannerLink ?? this.bannerLink,
      isRealScope: isRealScope ?? this.isRealScope,
      devices: devices ?? this.devices,
      groups: groups ?? this.groups,
      operationStatuses: operationStatuses ?? this.operationStatuses,
      latestStateByDeviceId: latestStateByDeviceId ?? this.latestStateByDeviceId,
      attentionDeviceIds: attentionDeviceIds ?? this.attentionDeviceIds,
    );
  }
}
