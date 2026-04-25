import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
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
    );
  }

  @override
  RecommendationsScreenState get mockState => RecommendationsScreenState(
    checkState: const AsyncValue.data(null),
    recommendations: _mockRecommendations,
  );

  @override
  RecommendationsScreenState get mockLoadingState =>
      const RecommendationsScreenState(
        checkState: AsyncValue.loading(),
        recommendations: [],
      );

  Future<void> loadRecommendations() async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    try {
      final repo = ref.read(recommendationsRepositoryProvider);
      final response = await repo.getRecommendations(limit: 50);
      final recommendations = <SoilRecommendationModel>[];
      for (var i = 0; i < response.items.length; i++) {
        final row = response.items[i];
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
            siteLabel: row.deviceId ?? 'Unknown device',
            createdAt: row.createdAt ?? row.insightDate ?? DateTime.now(),
          ),
        );
      }
      state = RecommendationsScreenState(
        checkState: const AsyncValue.data(null),
        recommendations: recommendations,
      );
    } catch (_) {
      state = RecommendationsScreenState(
        checkState: const AsyncValue.data(null),
        recommendations: _mockRecommendations,
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
}

class RecommendationsScreenState extends BaseState {
  final List<SoilRecommendationModel> recommendations;

  const RecommendationsScreenState({
    super.checkState,
    required this.recommendations,
  });

  RecommendationsScreenState copyWith({
    AsyncValue<String?>? checkState,
    List<SoilRecommendationModel>? recommendations,
  }) {
    return RecommendationsScreenState(
      checkState: checkState ?? this.checkState,
      recommendations: recommendations ?? this.recommendations,
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
