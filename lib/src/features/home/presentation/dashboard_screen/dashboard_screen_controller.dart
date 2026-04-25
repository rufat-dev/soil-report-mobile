import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/home/data/dashboard_devices_repository.dart';
import 'package:soilreport/src/features/home/domain/dashboard_device_model.dart';
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
      );

  Future<void> loadScreen({bool useCache = true}) async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    final devicesRepo = ref.read(dashboardDevicesRepositoryProvider);
    try {
      final results = await Future.wait([
        devicesRepo.getDevices(useCache: useCache),
        devicesRepo.getGroups(useCache: useCache),
        devicesRepo.getOperationStatuses(useCache: useCache),
      ]);
      state = state.copyWith(
        checkState: const AsyncValue.data(null),
        isRealScope: true,
        devices: results[0] as List<DashboardDeviceModel>,
        groups: results[1] as List<DeviceGroupModel>,
        operationStatuses: results[2] as List<OperationStatusClassifierModel>,
      );
    } catch (_) {
      state = state.copyWith(
        checkState: const AsyncValue.data(null),
        isRealScope: true,
      );
    }
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

  const DashboardScreenState({
    super.checkState,
    required this.stories,
    this.bannerImage,
    this.bannerLink,
    required this.isRealScope,
    required this.devices,
    required this.groups,
    required this.operationStatuses,
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
    );
  }
}
