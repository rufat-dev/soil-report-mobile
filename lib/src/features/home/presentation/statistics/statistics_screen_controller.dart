import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/home/domain/statistics/soil_statistic_model.dart';
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
    await Future<void>.delayed(const Duration(milliseconds: 600));
    state = StatisticsScreenState(
      checkState: const AsyncValue.data(null),
      stats: _mockStats,
      recentSamples: _mockSamples,
    );
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
  SoilStatisticModel(label: 'Avg pH', value: 6.5, unit: '', trend: SoilStatisticTrend.stable),
  SoilStatisticModel(label: 'Avg Moisture', value: 34.2, unit: '%', trend: SoilStatisticTrend.up),
  SoilStatisticModel(label: 'Nitrogen', value: 42, unit: 'ppm', trend: SoilStatisticTrend.down),
  SoilStatisticModel(label: 'Phosphorus', value: 28, unit: 'ppm', trend: SoilStatisticTrend.up),
  SoilStatisticModel(label: 'Potassium', value: 185, unit: 'ppm', trend: SoilStatisticTrend.stable),
  SoilStatisticModel(label: 'Organic Matter', value: 3.8, unit: '%', trend: SoilStatisticTrend.up),
];

final _mockSamples = [
  SoilSampleModel(
    id: 1, siteLabel: 'Field A – North', latitude: 40.4093, longitude: 49.8671,
    collectedAt: DateTime.now().subtract(const Duration(days: 2)),
    phLevel: 6.3, moisturePercent: 32.1, nitrogenPpm: 40,
    phosphorusPpm: 25, potassiumPpm: 180, organicMatterPercent: 3.5,
  ),
  SoilSampleModel(
    id: 2, siteLabel: 'Field B – South', latitude: 40.3890, longitude: 49.8502,
    collectedAt: DateTime.now().subtract(const Duration(days: 5)),
    phLevel: 6.8, moisturePercent: 36.4, nitrogenPpm: 44,
    phosphorusPpm: 31, potassiumPpm: 190, organicMatterPercent: 4.1,
  ),
  SoilSampleModel(
    id: 3, siteLabel: 'Greenhouse Plot', latitude: 40.4120, longitude: 49.8730,
    collectedAt: DateTime.now().subtract(const Duration(days: 10)),
    phLevel: 6.5, moisturePercent: 38.0, nitrogenPpm: 48,
    phosphorusPpm: 30, potassiumPpm: 175, organicMatterPercent: 4.5,
  ),
];
