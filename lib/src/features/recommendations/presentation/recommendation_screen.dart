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
    final recommendations = [...activeState.recommendations];
    final highPriority = recommendations
        .where((r) => r.priority == RecommendationPriority.high)
        .toList();
    final supportive = recommendations
        .where((r) => r.priority != RecommendationPriority.high)
        .toList();
    final forecasts = [...activeState.forecasts]
      ..sort((a, b) {
        final aa = a.forecastFor ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bb = b.forecastFor ?? DateTime.fromMillisecondsSinceEpoch(0);
        return aa.compareTo(bb);
      });

    return Container(
      width: 100.sw(context),
      color: colorScheme.surface,
      child: RefreshIndicator(
        color: colorScheme.primary,
        onRefresh: () => ref
            .read(recommendationsScreenControllerProvider.notifier)
            .loadRecommendations(forceRemote: true),
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
              _RecommendationsHeader(
                title: l10n.tab3Title,
                subtitle: l10n.recommendationsHeaderSubtitle,
              ),
              const SizedBox(height: 16),
              _RecommendationsSummaryStrip(
                highCount: highPriority.length,
                supportCount: supportive.length,
                forecastCount: forecasts.length,
              ),
              const SizedBox(height: 14),
              if (activeState.hasLoadError &&
                  !isLoading &&
                  recommendations.isEmpty &&
                  forecasts.isEmpty)
                _ErrorStateCard(
                  onRetry: () => ref
                      .read(recommendationsScreenControllerProvider.notifier)
                      .loadRecommendations(forceRemote: true),
                )
              else if (recommendations.isEmpty &&
                  forecasts.isEmpty &&
                  !isLoading)
                StandardEmptyView(
                  title: l10n.emptyRecommendationsTitle,
                  subtitle: l10n.recommendationsEmptyStableSubtitle,
                  icon: Icons.lightbulb_outline,
                ),
              if (isLoading) ...[
                _SectionHeader(
                  title: l10n.recommendationsNeedsAttentionTitle,
                  subtitle: l10n.recommendationsNeedsAttentionSubtitle,
                ),
                ...List.generate(2, (_) => _buildRecommendationSkeleton(context)),
                const SizedBox(height: 10),
                _SectionHeader(
                  title: l10n.recommendationsSuggestedActionsTitle,
                  subtitle: l10n.recommendationsSuggestedActionsSubtitle,
                ),
                ...List.generate(2, (_) => _buildRecommendationSkeleton(context)),
              ] else ...[
                if (highPriority.isNotEmpty) ...[
                  _SectionHeader(
                    title: l10n.recommendationsNeedsAttentionTitle,
                    subtitle: l10n.recommendationsNeedsAttentionSubtitle,
                  ),
                  ...highPriority.map((r) => _buildRecommendationCard(context, r)),
                ],
                if (supportive.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _SectionHeader(
                    title: l10n.recommendationsSuggestedActionsTitle,
                    subtitle: l10n.recommendationsSuggestedActionsSubtitle,
                  ),
                  ...supportive.map((r) => _buildRecommendationCard(context, r)),
                ],
              ],
              if (forecasts.isNotEmpty) ...[
                const SizedBox(height: 18),
                _SectionHeader(
                  title: l10n.recommendationsForecastOutlookTitle,
                  subtitle: l10n.recommendationsForecastOutlookSubtitle,
                ),
                ...forecasts.take(6).map((f) => _buildForecastCard(context, f)),
              ],
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

    final categoryLabel = _categoryLabel(rec.category);
    final recency = _recencyText(rec.createdAt);
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
      padding: const EdgeInsets.all(12),
      decoration: AppTheme().appCardDecoration(context, borderRadius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: priorityColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(rec.title, style: Theme.of(context).textTheme.titleSmall),
              ),
              const SizedBox(width: 8),
              Text(
                recency,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withAlpha(15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  categoryLabel,
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.recommendationsDeviceLabel(rec.siteLabel),
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
      decoration: AppTheme().appCardDecoration(context, borderRadius: 12),
      child: const Skeleton.leaf(
        child: SizedBox(height: 100, width: double.infinity),
      ),
    );
  }

  Widget _buildForecastCard(BuildContext context, AiForecastItem forecast) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final risk = _forecastRisk(forecast);
    final riskColor = _riskColor(context, risk);
    final when = forecast.forecastFor;
    final subtitle = when == null
        ? (forecast.confidence ?? l10n.recommendationsNoForecastHorizon)
        : '${when.day.toString().padLeft(2, '0')}.${when.month.toString().padLeft(2, '0')} ${when.hour.toString().padLeft(2, '0')}:${when.minute.toString().padLeft(2, '0')}';
    final deviceLabel = forecast.deviceId == null || forecast.deviceId!.isEmpty
        ? l10n.recommendationsUnknownDevice
        : l10n.recommendationsDeviceShort(_shortDeviceId(forecast.deviceId!));

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: AppTheme().appCardDecoration(context, borderRadius: 12),
      child: Row(
        children: [
          Icon(Icons.timeline_rounded, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  forecast.metric ?? l10n.recommendationsPredictedMetric,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _InlineBadge(
                      text: risk,
                      color: riskColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        deviceLabel,
                        style: Theme.of(context).textTheme.labelSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            forecast.predictedValue == null
                ? '-'
                : '${forecast.predictedValue!.toStringAsFixed(1)} ${forecast.unit ?? ''}',
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  String _categoryLabel(RecommendationCategory category) {
    final l10n = AppLocalizations.of(context);
    return switch (category) {
      RecommendationCategory.fertilization => l10n.recommendationsCategoryFertilization,
      RecommendationCategory.irrigation => l10n.recommendationsCategoryIrrigation,
      RecommendationCategory.soilAmendment => l10n.recommendationsCategorySoil,
      RecommendationCategory.pestControl => l10n.recommendationsCategoryPest,
      RecommendationCategory.general => l10n.recommendationsCategoryGeneral,
    };
  }

  String _recencyText(DateTime createdAt) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 60) return l10n.recommendationsRecencyMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.recommendationsRecencyHoursAgo(diff.inHours);
    return l10n.recommendationsRecencyDaysAgo(diff.inDays);
  }

  String _shortDeviceId(String id) {
    if (id.length <= 8) return id;
    return '${id.substring(0, 4)}...${id.substring(id.length - 4)}';
  }

  String _forecastRisk(AiForecastItem f) {
    final l10n = AppLocalizations.of(context);
    final metric = (f.metric ?? '').toLowerCase();
    final v = f.predictedValue;
    if (v == null) return l10n.recommendationsRiskMonitor;
    if (metric.contains('moisture')) {
      if (v < 25 || v > 75) return l10n.recommendationsRiskRisk;
      if (v < 30 || v > 65) return l10n.recommendationsRiskWatch;
      return l10n.recommendationsRiskStable;
    }
    if (metric.contains('ph')) {
      if (v < 5.5 || v > 8.0) return l10n.recommendationsRiskRisk;
      if (v < 6.0 || v > 7.5) return l10n.recommendationsRiskWatch;
      return l10n.recommendationsRiskStable;
    }
    if (metric.contains('conduct')) {
      if (v < 300 || v > 2600) return l10n.recommendationsRiskRisk;
      if (v < 500 || v > 2200) return l10n.recommendationsRiskWatch;
      return l10n.recommendationsRiskStable;
    }
    return l10n.recommendationsRiskMonitor;
  }

  Color _riskColor(BuildContext context, String risk) {
    final l10n = AppLocalizations.of(context);
    return switch (risk) {
      final r when r == l10n.recommendationsRiskRisk => AppTheme().error,
      final r when r == l10n.recommendationsRiskWatch => AppTheme().warning,
      final r when r == l10n.recommendationsRiskStable => AppTheme().success,
      _ => Theme.of(context).colorScheme.secondary,
    };
  }
}

class _RecommendationsHeader extends StatelessWidget {
  const _RecommendationsHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _RecommendationsSummaryStrip extends StatelessWidget {
  const _RecommendationsSummaryStrip({
    required this.highCount,
    required this.supportCount,
    required this.forecastCount,
  });

  final int highCount;
  final int supportCount;
  final int forecastCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppTheme().appCardDecoration(context, borderRadius: 14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _InlineBadge(
            text: l10n.recommendationsSummaryUrgent(highCount),
            color: highCount > 0 ? AppTheme().error : AppTheme().success,
          ),
          _InlineBadge(
            text: l10n.recommendationsSummarySuggested(supportCount),
            color: scheme.secondary,
          ),
          _InlineBadge(
            text: l10n.recommendationsSummaryForecasts(forecastCount),
            color: scheme.primary,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 2),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _InlineBadge extends StatelessWidget {
  const _InlineBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _ErrorStateCard extends StatelessWidget {
  const _ErrorStateCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme().appCardDecoration(context, borderRadius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.recommendationsLoadErrorTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.recommendationsLoadErrorSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(l10n.authRetry),
          ),
        ],
      ),
    );
  }
}
