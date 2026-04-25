import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/home/data/dashboard_devices_repository.dart';
import 'package:soilreport/src/features/home/domain/dashboard_device_model.dart';

part 'add_device_screen_controller.g.dart';

@riverpod
class AddDeviceScreenController extends _$AddDeviceScreenController
    with MockableControllerMixin<AddDeviceScreenState> {
  @override
  AddDeviceScreenState build() {
    return const AddDeviceScreenState(
      checkState: null,
      devices: [],
      groups: [],
      plants: [],
      soils: [],
      submitSuccess: false,
    );
  }

  @override
  AddDeviceScreenState get mockState => state;

  @override
  AddDeviceScreenState get mockLoadingState => state;

  Future<void> loadFormData({bool useCache = true}) async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    try {
      final repo = ref.read(dashboardDevicesRepositoryProvider);
      final results = await Future.wait([
        repo.getDevices(useCache: useCache),
        repo.getGroups(useCache: useCache),
        // Always refresh classifiers so newly added plant/soil types are visible immediately.
        repo.getPlants(useCache: false),
        repo.getSoils(useCache: false),
      ]);
      state = state.copyWith(
        checkState: const AsyncValue.data(null),
        devices: results[0] as List<DashboardDeviceModel>,
        groups: results[1] as List<DeviceGroupModel>,
        plants: results[2] as List<PlantClassifierModel>,
        soils: results[3] as List<SoilClassifierModel>,
      );
    } catch (_) {
      state = state.copyWith(checkState: const AsyncValue.data(null));
    }
  }

  DashboardDeviceModel? resolveGroupTemplateDevice(String? groupId) {
    if (groupId == null || groupId.isEmpty) {
      return null;
    }
    for (final device in state.devices) {
      if (device.groupId == groupId) {
        return device;
      }
    }
    return null;
  }

  Future<bool> submit(DeviceCreatePayload payload) async {
    state = state.copyWith(
      checkState: const AsyncValue.loading(),
      submitSuccess: false,
    );
    try {
      final repo = ref.read(dashboardDevicesRepositoryProvider);
      await repo.createDevice(payload);
      final refreshedDevices = await repo.getDevices(useCache: false);
      state = state.copyWith(
        checkState: const AsyncValue.data(null),
        submitSuccess: true,
        devices: refreshedDevices,
      );
      return true;
    } catch (_) {
      state = state.copyWith(
        checkState: const AsyncValue.data(null),
        submitSuccess: false,
      );
      return false;
    }
  }
}

class AddDeviceScreenState extends BaseState {
  final List<DashboardDeviceModel> devices;
  final List<DeviceGroupModel> groups;
  final List<PlantClassifierModel> plants;
  final List<SoilClassifierModel> soils;
  final bool submitSuccess;

  const AddDeviceScreenState({
    super.checkState,
    required this.devices,
    required this.groups,
    required this.plants,
    required this.soils,
    required this.submitSuccess,
  });

  AddDeviceScreenState copyWith({
    AsyncValue<String?>? checkState,
    List<DashboardDeviceModel>? devices,
    List<DeviceGroupModel>? groups,
    List<PlantClassifierModel>? plants,
    List<SoilClassifierModel>? soils,
    bool? submitSuccess,
  }) {
    return AddDeviceScreenState(
      checkState: checkState ?? this.checkState,
      devices: devices ?? this.devices,
      groups: groups ?? this.groups,
      plants: plants ?? this.plants,
      soils: soils ?? this.soils,
      submitSuccess: submitSuccess ?? this.submitSuccess,
    );
  }
}
