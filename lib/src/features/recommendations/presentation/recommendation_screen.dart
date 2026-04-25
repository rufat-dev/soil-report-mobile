import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:soilreport/src/common_widgets/standard_empty_view.dart';
import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/features/recommendations/domain/soil_recommendation_model.dart';
import 'package:soilreport/src/features/recommendations/presentation/recommendations_screen_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';

class RecommendationScreen extends ConsumerStatefulWidget {
  const RecommendationScreen({super.key});

  @override
  ConsumerState<RecommendationScreen> createState() =>
      _RecommendationScreenState();
}

class _RecommendationScreenState extends ConsumerState<RecommendationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recommendationsScreenControllerProvider.notifier)
          .loadRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(recommendationsScreenControllerProvider);
    final activeState = ref
        .read(recommendationsScreenControllerProvider.notifier)
        .effectiveState;
    final isLoading = activeState.checkState.isNullOrLoading;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 100.sw(context),
      color: colorScheme.surface,
      child: RefreshIndicator(
        color: colorScheme.primary,
        onRefresh: () => ref
            .read(recommendationsScreenControllerProvider.notifier)
            .loadRecommendations(),
        child: Skeletonizer(
          enabled: isLoading,
          effect: PulseEffect(
            from: AppTheme().elevatedSurface(context).withAlpha(100),
            to: AppTheme().elevatedSurface(context).withAlpha(240),
            duration: const Duration(milliseconds: 800),
          ),
          child: ListView(
            padding: EdgeInsets.only(
              top: 100.devicePaddingTop(context) + 15,
              left: 16,
              right: 16,
              bottom: 24,
            ),
            children: [
              Text(
                l10n.tab3Title,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              if (activeState.recommendations.isEmpty && !isLoading)
                StandardEmptyView(
                  title: l10n.emptyRecommendationsTitle,
                  subtitle: l10n.emptyRecommendationsSubtitle,
                  icon: Icons.lightbulb_outline,
                ),
              ...activeState.recommendations.isEmpty && isLoading
                  ? List.generate(
                      4,
                      (_) => _buildRecommendationSkeleton(context),
                    )
                  : activeState.recommendations.map(
                      (r) => _buildRecommendationCard(context, r),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    SoilRecommendationModel rec,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    final priorityColor = switch (rec.priority) {
      RecommendationPriority.high => AppTheme().error,
      RecommendationPriority.medium => AppTheme().warning,
      RecommendationPriority.low => AppTheme().success,
    };
    final priorityLabel = switch (rec.priority) {
      RecommendationPriority.high => l10n.recommendationsPriorityHigh,
      RecommendationPriority.medium => l10n.recommendationsPriorityMedium,
      RecommendationPriority.low => l10n.recommendationsPriorityLow,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme().cardSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rec.title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(rec.description, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: priorityColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  priorityLabel,
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rec.siteLabel,
                  style: Theme.of(context).textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationSkeleton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme().cardSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: const Skeleton.leaf(
        child: SizedBox(height: 100, width: double.infinity),
      ),
    );
  }
}
