import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/home/data/dashboard_devices_repository.dart';
import 'package:soilreport/src/features/home/domain/dashboard_device_model.dart';

part 'add_group_screen_controller.g.dart';

@riverpod
class AddGroupScreenController extends _$AddGroupScreenController
    with MockableControllerMixin<AddGroupScreenState> {
  @override
  AddGroupScreenState build() {
    return const AddGroupScreenState(
      checkState: null,
      devices: [],
      devicesLoading: true,
    );
  }

  @override
  AddGroupScreenState get mockState => state;

  @override
  AddGroupScreenState get mockLoadingState => state;

  /// Loads the caller's devices so ungrouped ones can be attached via `device_ids` on POST /groups.
  Future<void> loadDevices({bool useCache = true}) async {
    state = state.copyWith(devicesLoading: true);
    try {
      final list = await ref
          .read(dashboardDevicesRepositoryProvider)
          .getDevices(useCache: useCache);
      state = state.copyWith(devicesLoading: false, devices: list);
    } catch (_) {
      state = state.copyWith(devicesLoading: false, devices: const []);
    }
  }

  Future<bool> submit(GroupCreatePayload payload) async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    try {
      await ref.read(dashboardDevicesRepositoryProvider).createGroup(payload);
      state = state.copyWith(checkState: const AsyncValue.data(null));
      return true;
    } catch (_) {
      state = state.copyWith(checkState: const AsyncValue.data(null));
      return false;
    }
  }
}

class AddGroupScreenState extends BaseState {
  final List<DashboardDeviceModel> devices;
  final bool devicesLoading;

  const AddGroupScreenState({
    super.checkState,
    required this.devices,
    required this.devicesLoading,
  });

  AddGroupScreenState copyWith({
    AsyncValue<String?>? checkState,
    List<DashboardDeviceModel>? devices,
    bool? devicesLoading,
  }) {
    return AddGroupScreenState(
      checkState: checkState ?? this.checkState,
      devices: devices ?? this.devices,
      devicesLoading: devicesLoading ?? this.devicesLoading,
    );
  }
}
