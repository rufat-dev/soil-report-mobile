import 'package:flutter/foundation.dart';
import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/home/data/dashboard_devices_repository.dart';
import 'package:soilreport/src/features/recommendations/data/recommendations_repository.dart';
import 'package:soilreport/src/features/recommendations/domain/soil_recommendation_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommendations_screen_controller.g.dart';

@riverpod
class RecommendationsScreenController extends _$RecommendationsScreenController
    with MockableControllerMixin<RecommendationsScreenState> {
  @override
  RecommendationsScreenState build() {
    return const RecommendationsScreenState(
      checkState: null,
      recommendations: [],
      forecasts: [],
      hasLoadError: false,
    );
  }

  @override
  RecommendationsScreenState get mockState => RecommendationsScreenState(
    checkState: const AsyncValue.data(null),
    recommendations: _mockRecommendations,
    forecasts: const [],
    hasLoadError: false,
  );

  @override
  RecommendationsScreenState get mockLoadingState =>
      const RecommendationsScreenState(
        checkState: AsyncValue.loading(),
        recommendations: [],
        forecasts: [],
        hasLoadError: false,
      );

  /// When [forceRemote] is true (pull-to-refresh / retry), skips cache on devices
  /// and AI recommendation/forecast endpoints.
  Future<void> loadRecommendations({bool forceRemote = false}) async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    final useCache = !forceRemote;
    try {
      final repo = ref.read(recommendationsRepositoryProvider);
      final devicesRepo = ref.read(dashboardDevicesRepositoryProvider);
      final devices = await devicesRepo.getDevices(useCache: useCache);
      final deviceNameById = {
        for (final d in devices)
          d.deviceId: (d.deviceName?.trim().isNotEmpty ?? false)
              ? d.deviceName!.trim()
              : d.deviceId,
      };
      final response =
          await repo.getRecommendations(limit: 50, useCache: useCache);
      final forecasts = await repo.getForecasts(limit: 20, useCache: useCache);
      final cutoff = DateTime.now().subtract(const Duration(days: 7));
      final recommendations = <SoilRecommendationModel>[];
      for (var i = 0; i < response.items.length; i++) {
        final row = response.items[i];
        final recommendationAt = row.insightDate ?? row.createdAt ?? DateTime.now();
        if (recommendationAt.isBefore(cutoff)) {
          continue;
        }
        final rowJson = row.toJson();
        recommendations.add(
          SoilRecommendationModel(
            id: i + 1,
            title: (row.title?.trim().isNotEmpty ?? false)
                ? row.title!
                : (row.recommendation ?? 'Recommendation'),
            description: (row.summary?.trim().isNotEmpty ?? false)
                ? row.summary!
                : (row.recommendation ?? ''),
            category: _categoryFromRow(rowJson),
            priority: _priorityFromRow(row.priority),
            siteLabel: _formatDeviceLabel(row.deviceId, deviceNameById),
            // Use insight_date as the advisory timestamp shown in UI recency labels.
            createdAt: recommendationAt,
          ),
        );
      }
      recommendations.sort((a, b) {
        final byPriority = _priorityRank(a.priority).compareTo(
          _priorityRank(b.priority),
        );
        if (byPriority != 0) return byPriority;
        return b.createdAt.compareTo(a.createdAt);
      });
      state = RecommendationsScreenState(
        checkState: const AsyncValue.data(null),
        recommendations: recommendations,
        forecasts: forecasts,
        hasLoadError: false,
      );
    } catch (e, st) {
      debugPrint('Recommendations load failed: $e');
      debugPrintStack(stackTrace: st);
      state = RecommendationsScreenState(
        checkState: const AsyncValue.data(null),
        recommendations: const [],
        forecasts: const [],
        hasLoadError: true,
      );
    }
  }

  Future<void> markAsApplied(int id) async {
    final updated = state.recommendations
        .map((r) => r.id == id ? r.copyWith(isApplied: true) : r)
        .toList();
    state = state.copyWith(recommendations: updated);
  }

  RecommendationPriority _priorityFromRow(String? value) {
    switch (value?.toLowerCase()) {
      case 'high':
      case 'critical':
        return RecommendationPriority.high;
      case 'low':
        return RecommendationPriority.low;
      default:
        return RecommendationPriority.medium;
    }
  }

  RecommendationCategory _categoryFromRow(Map<String, dynamic> row) {
    final text =
        '${row['reasoning_scope'] ?? ''} ${row['recommendation'] ?? ''}'
            .toLowerCase();
    if (text.contains('fertiliz')) return RecommendationCategory.fertilization;
    if (text.contains('irrig') || text.contains('moisture')) {
      return RecommendationCategory.irrigation;
    }
    if (text.contains('soil') ||
        text.contains('ph') ||
        text.contains('amend')) {
      return RecommendationCategory.soilAmendment;
    }
    if (text.contains('pest')) return RecommendationCategory.pestControl;
    return RecommendationCategory.general;
  }

  int _priorityRank(RecommendationPriority p) {
    return switch (p) {
      RecommendationPriority.high => 0,
      RecommendationPriority.medium => 1,
      RecommendationPriority.low => 2,
    };
  }

  String _formatDeviceLabel(
    String? deviceId,
    Map<String, String> deviceNameById,
  ) {
    if (deviceId == null || deviceId.isEmpty) return 'Unknown device';
    final name = deviceNameById[deviceId];
    if (name == null || name == deviceId) {
      return 'Device ${_shortDeviceId(deviceId)}';
    }
    return '$name (${_shortDeviceId(deviceId)})';
  }

  String _shortDeviceId(String id) {
    if (id.length <= 8) return id;
    return '${id.substring(0, 4)}...${id.substring(id.length - 4)}';
  }
}

class RecommendationsScreenState extends BaseState {
  final List<SoilRecommendationModel> recommendations;
  final List<AiForecastItem> forecasts;
  final bool hasLoadError;

  const RecommendationsScreenState({
    super.checkState,
    required this.recommendations,
    required this.forecasts,
    required this.hasLoadError,
  });

  RecommendationsScreenState copyWith({
    AsyncValue<String?>? checkState,
    List<SoilRecommendationModel>? recommendations,
    List<AiForecastItem>? forecasts,
    bool? hasLoadError,
  }) {
    return RecommendationsScreenState(
      checkState: checkState ?? this.checkState,
      recommendations: recommendations ?? this.recommendations,
      forecasts: forecasts ?? this.forecasts,
      hasLoadError: hasLoadError ?? this.hasLoadError,
    );
  }
}

final _mockRecommendations = [
  SoilRecommendationModel(
    id: 1,
    title: 'Apply Nitrogen Fertilizer',
    description:
        'Field B – South nitrogen levels are at 28 ppm. Apply urea at 50 kg/ha to reach optimal 45–55 ppm range.',
    category: RecommendationCategory.fertilization,
    priority: RecommendationPriority.high,
    siteLabel: 'Field B – South',
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
  ),
];
