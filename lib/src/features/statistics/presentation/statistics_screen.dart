import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:soilreport/src/common_widgets/standard_empty_view.dart';
import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/features/statistics/domain/soil_statistic_model.dart';
import 'package:soilreport/src/features/statistics/presentation/statistics_screen_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';

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
    final activeState = ref
        .read(statisticsScreenControllerProvider.notifier)
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
              if (activeState.stats.isEmpty && !isLoading)
                StandardEmptyView(
                  title: l10n.emptyStatisticsTitle,
                  subtitle: l10n.emptyStatisticsSubtitle,
                  icon: Icons.query_stats_outlined,
                )
              else
                _buildStatGrid(context, activeState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatGrid(BuildContext context, StatisticsScreenState state) {
    final stats = state.stats;
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
          Text(
            stat.unit.isEmpty
                ? stat.value.toStringAsFixed(1)
                : '${stat.value.toStringAsFixed(1)} ${stat.unit}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
