import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/home/domain/recommendations/soil_recommendation_model.dart';
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
    await Future<void>.delayed(const Duration(milliseconds: 600));
    state = RecommendationsScreenState(
      checkState: const AsyncValue.data(null),
      recommendations: _mockRecommendations,
    );
  }

  Future<void> markAsApplied(int id) async {
    final updated = state.recommendations
        .map((r) => r.id == id ? r.copyWith(isApplied: true) : r)
        .toList();
    state = state.copyWith(recommendations: updated);
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
    description: 'Field B – South nitrogen levels are at 28 ppm. Apply urea at 50 kg/ha to reach optimal 45–55 ppm range.',
    category: RecommendationCategory.fertilization,
    priority: RecommendationPriority.high,
    siteLabel: 'Field B – South',
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
  ),
  SoilRecommendationModel(
    id: 2,
    title: 'Increase Irrigation Frequency',
    description: 'Moisture in Field A – North is consistently below 25%. Increase drip irrigation schedule from 2x to 3x weekly.',
    category: RecommendationCategory.irrigation,
    priority: RecommendationPriority.high,
    siteLabel: 'Field A – North',
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  SoilRecommendationModel(
    id: 3,
    title: 'Add Lime Amendment',
    description: 'Greenhouse Plot pH trending acidic (5.8). Apply agricultural lime at 2 tons/ha to restore 6.2–6.8 range.',
    category: RecommendationCategory.soilAmendment,
    priority: RecommendationPriority.medium,
    siteLabel: 'Greenhouse Plot',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  SoilRecommendationModel(
    id: 4,
    title: 'Rotate Cover Crops',
    description: 'Organic matter in Field A – North has plateaued at 3.5%. Consider planting clover or vetch as winter cover crop.',
    category: RecommendationCategory.general,
    priority: RecommendationPriority.low,
    siteLabel: 'Field A – North',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    isApplied: true,
  ),
];
