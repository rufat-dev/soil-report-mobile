import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/statistics/data/statistics_repository.dart';
import 'package:soilreport/src/features/statistics/domain/soil_statistic_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_screen_controller.g.dart';

@riverpod
class StatisticsScreenController extends _$StatisticsScreenController
    with MockableControllerMixin<StatisticsScreenState> {
  @override
  StatisticsScreenState build() {
    return const StatisticsScreenState(
      checkState: null,
      stats: [],
      recentSamples: [],
    );
  }

  @override
  StatisticsScreenState get mockState => StatisticsScreenState(
    checkState: const AsyncValue.data(null),
    stats: _mockStats,
    recentSamples: _mockSamples,
  );

  @override
  StatisticsScreenState get mockLoadingState => const StatisticsScreenState(
    checkState: AsyncValue.loading(),
    stats: [],
    recentSamples: [],
  );

  Future<void> loadStatistics() async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    try {
      final repo = ref.read(statisticsRepositoryProvider);
      final devices = await repo.getDevices();
      if (devices.items.isEmpty) {
        state = const StatisticsScreenState(
          checkState: AsyncValue.data(null),
          stats: [],
          recentSamples: [],
        );
        return;
      }

      final deviceId = devices.items.first.deviceId;
      if (deviceId == null || deviceId.isEmpty) {
        state = const StatisticsScreenState(
          checkState: AsyncValue.data(null),
          stats: [],
          recentSamples: [],
        );
        return;
      }

      final latest = await repo.getDeviceStateLatest(deviceId);
      final hourly = await repo.getDeviceTimeseriesHourly(deviceId, limit: 12);
      final points = hourly?.points ?? const <DeviceTimeseriesPointResponse>[];

      final stats = <SoilStatisticModel>[
        SoilStatisticModel(
          label: 'Avg pH',
          value: latest?.phValue ?? 0,
          unit: '',
        ),
        SoilStatisticModel(
          label: 'Avg Moisture',
          value: latest?.moisture ?? 0,
          unit: '%',
          trend: _trendFromText(latest?.moistureTrend),
        ),
        SoilStatisticModel(
          label: 'Conductivity',
          value: latest?.conductivity ?? 0,
          unit: 'uS/cm',
          trend: _trendFromText(latest?.conductivityTrend),
        ),
        SoilStatisticModel(
          label: 'Nitrogen',
          value: latest?.npkN ?? 0,
          unit: 'ppm',
        ),
        SoilStatisticModel(
          label: 'Phosphorus',
          value: latest?.npkP ?? 0,
          unit: 'ppm',
        ),
        SoilStatisticModel(
          label: 'Potassium',
          value: latest?.npkK ?? 0,
          unit: 'ppm',
        ),
      ];

      final recentSamples = <SoilSampleModel>[];
      for (var i = 0; i < points.length && i < 3; i++) {
        final p = points[points.length - 1 - i];
        recentSamples.add(
          SoilSampleModel(
            id: i + 1,
            siteLabel: deviceId,
            latitude: 0,
            longitude: 0,
            collectedAt: p.hourTs ?? DateTime.now(),
            phLevel: p.avgPhValue ?? 0,
            moisturePercent: p.avgMoisture ?? 0,
            nitrogenPpm: latest?.npkN ?? 0,
            phosphorusPpm: latest?.npkP ?? 0,
            potassiumPpm: latest?.npkK ?? 0,
            organicMatterPercent: 0,
          ),
        );
      }

      state = StatisticsScreenState(
        checkState: const AsyncValue.data(null),
        stats: stats,
        recentSamples: recentSamples,
      );
    } catch (_) {
      state = StatisticsScreenState(
        checkState: const AsyncValue.data(null),
        stats: _mockStats,
        recentSamples: _mockSamples,
      );
    }
  }

  SoilStatisticTrend _trendFromText(String? value) {
    switch (value?.toLowerCase()) {
      case 'rising':
      case 'up':
        return SoilStatisticTrend.up;
      case 'falling':
      case 'down':
        return SoilStatisticTrend.down;
      default:
        return SoilStatisticTrend.stable;
    }
  }
}

class StatisticsScreenState extends BaseState {
  final List<SoilStatisticModel> stats;
  final List<SoilSampleModel> recentSamples;

  const StatisticsScreenState({
    super.checkState,
    required this.stats,
    required this.recentSamples,
  });

  StatisticsScreenState copyWith({
    AsyncValue<String?>? checkState,
    List<SoilStatisticModel>? stats,
    List<SoilSampleModel>? recentSamples,
  }) {
    return StatisticsScreenState(
      checkState: checkState ?? this.checkState,
      stats: stats ?? this.stats,
      recentSamples: recentSamples ?? this.recentSamples,
    );
  }
}

const _mockStats = [
  SoilStatisticModel(
    label: 'Avg pH',
    value: 6.5,
    unit: '',
    trend: SoilStatisticTrend.stable,
  ),
  SoilStatisticModel(
    label: 'Avg Moisture',
    value: 34.2,
    unit: '%',
    trend: SoilStatisticTrend.up,
  ),
];

final _mockSamples = [
  SoilSampleModel(
    id: 1,
    siteLabel: 'Field A – North',
    latitude: 40.4093,
    longitude: 49.8671,
    collectedAt: DateTime.now().subtract(const Duration(days: 2)),
    phLevel: 6.3,
    moisturePercent: 32.1,
    nitrogenPpm: 40,
    phosphorusPpm: 25,
    potassiumPpm: 180,
    organicMatterPercent: 3.5,
  ),
];
