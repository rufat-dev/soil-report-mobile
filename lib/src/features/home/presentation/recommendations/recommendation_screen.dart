import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/features/home/domain/recommendations/soil_recommendation_model.dart';
import 'package:soilreport/src/features/home/presentation/recommendations/recommendations_screen_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecommendationScreen extends ConsumerStatefulWidget {
  const RecommendationScreen({super.key});

  @override
  ConsumerState<RecommendationScreen> createState() => _RecommendationScreenState();
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
          effect: AppTheme().skeletonPulseEffect(context),
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
              ...activeState.recommendations.isEmpty && isLoading
                  ? List.generate(
                      4, (_) => _buildRecommendationSkeleton(context))
                  : activeState.recommendations
                      .map((r) => _buildRecommendationCard(context, r)),
              if (activeState.recommendations.isEmpty && !isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme().success.withAlpha(15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.thumb_up_alt_outlined,
                              size: 48, color: AppTheme().success),
                        ),
                        const SizedBox(height: 16),
                        Text(l10n.recommendationsNoItems,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
      BuildContext context, SoilRecommendationModel rec) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    final categoryIcon = switch (rec.category) {
      RecommendationCategory.fertilization => Icons.science_rounded,
      RecommendationCategory.irrigation => Icons.water_drop_rounded,
      RecommendationCategory.soilAmendment => Icons.landscape_rounded,
      RecommendationCategory.pestControl => Icons.bug_report_rounded,
      RecommendationCategory.general => Icons.eco_rounded,
    };
    final categoryColor = switch (rec.category) {
      RecommendationCategory.fertilization => AppTheme().info,
      RecommendationCategory.irrigation => const Color(0xFF3182CE),
      RecommendationCategory.soilAmendment => AppTheme().accent,
      RecommendationCategory.pestControl => AppTheme().warning,
      RecommendationCategory.general => colorScheme.primary,
    };
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
        border: Border.all(
          color: rec.isApplied
              ? AppTheme().success.withAlpha(50)
              : colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: categoryColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(categoryIcon, color: categoryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rec.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(rec.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: priorityColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  priorityLabel,
                  style: TextStyle(
                      color: priorityColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.location_on_outlined,
                  size: 13, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 3),
              Expanded(
                child: Text(rec.siteLabel,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontSize: 10),
                    overflow: TextOverflow.ellipsis),
              ),
              if (!rec.isApplied)
                GestureDetector(
                  onTap: () => ref
                      .read(recommendationsScreenControllerProvider.notifier)
                      .markAsApplied(rec.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.recommendationsMarkApplied,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 16, color: AppTheme().success),
                    const SizedBox(width: 4),
                    Text(
                      l10n.recommendationsApplied,
                      style: TextStyle(
                          color: AppTheme().success,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
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
            color: Theme.of(context).colorScheme.outlineVariant, width: 1),
      ),
      child: const Skeleton.leaf(
          child: SizedBox(height: 100, width: double.infinity)),
    );
  }
}
