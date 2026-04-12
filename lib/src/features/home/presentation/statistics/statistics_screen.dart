import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/features/home/domain/statistics/soil_statistic_model.dart';
import 'package:soilreport/src/features/home/presentation/statistics/statistics_screen_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

  class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statisticsScreenControllerProvider.notifier).loadStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(statisticsScreenControllerProvider);
    final activeState =
        ref.read(statisticsScreenControllerProvider.notifier).effectiveState;
    final isLoading = activeState.checkState.isNullOrLoading;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 100.sw(context),
      color: colorScheme.surface,
      child: RefreshIndicator(
        color: colorScheme.primary,
        onRefresh: () => ref
            .read(statisticsScreenControllerProvider.notifier)
            .loadStatistics(),
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
                l10n.tab1Title,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 20),
              _buildStatGrid(context, activeState),
              const SizedBox(height: 24),
              Text(
                l10n.statisticsRecentSamples,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              ...activeState.recentSamples.isEmpty && isLoading
                  ? List.generate(3, (_) => _buildSampleCardSkeleton(context))
                  : activeState.recentSamples
                      .map((s) => _buildSampleCard(context, s)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatGrid(BuildContext context, StatisticsScreenState state) {
    final stats = state.stats.isEmpty
        ? List.generate(
            6,
            (_) => const SoilStatisticModel(
                label: 'Loading', value: 0, unit: ''))
        : state.stats;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.0,
      children: stats.map((s) => _buildStatCard(context, s)).toList(),
    );
  }

  Widget _buildStatCard(BuildContext context, SoilStatisticModel stat) {
    final colorScheme = Theme.of(context).colorScheme;
    final trendIcon = switch (stat.trend) {
      SoilStatisticTrend.up => Icons.trending_up_rounded,
      SoilStatisticTrend.down => Icons.trending_down_rounded,
      SoilStatisticTrend.stable => Icons.trending_flat_rounded,
    };
    final trendColor = switch (stat.trend) {
      SoilStatisticTrend.up => AppTheme().success,
      SoilStatisticTrend.down => AppTheme().error,
      SoilStatisticTrend.stable => colorScheme.onSurfaceVariant,
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme().cardSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: trendColor.withAlpha(20),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(trendIcon, color: trendColor, size: 18),
          ),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(
              stat.unit.isEmpty
                  ? stat.value.toStringAsFixed(1)
                  : '${stat.value.toStringAsFixed(stat.value.truncateToDouble() == stat.value ? 0 : 1)} ${stat.unit}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            child: Text(
              stat.label,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleCard(BuildContext context, SoilSampleModel sample) {
    final colorScheme = Theme.of(context).colorScheme;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 16, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        sample.siteLabel,
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant.withAlpha(80),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _formatDate(sample.collectedAt),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildMiniStat(context, 'pH', sample.phLevel.toStringAsFixed(1)),
              _buildMiniStat(
                  context, 'Moisture', '${sample.moisturePercent.toStringAsFixed(1)}%'),
              _buildMiniStat(context, 'N', '${sample.nitrogenPpm.toStringAsFixed(0)} ppm'),
              _buildMiniStat(context, 'P', '${sample.phosphorusPpm.toStringAsFixed(0)} ppm'),
              _buildMiniStat(context, 'K', '${sample.potassiumPpm.toStringAsFixed(0)} ppm'),
              _buildMiniStat(
                  context, 'OM', '${sample.organicMatterPercent.toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(value,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(fontWeight: FontWeight.w700)),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _buildSampleCardSkeleton(BuildContext context) {
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
          child: SizedBox(height: 80, width: double.infinity)),
    );
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
