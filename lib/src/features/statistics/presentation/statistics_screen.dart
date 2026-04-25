import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:soilreport/src/common_widgets/standard_empty_view.dart';
import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/features/statistics/domain/soil_statistic_model.dart';
import 'package:soilreport/src/features/statistics/data/statistics_repository.dart';
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
  _ChartRange _selectedRange = _ChartRange.week;
  _MetricWindow _metricWindow = _MetricWindow.week;

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
    final filteredSamples = _samplesForRange(activeState.recentSamples);
    final filteredTrendPoints = _trendPointsForRange(activeState.trendPoints);

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
              _StatisticsHeader(
                title: l10n.tab1Title,
                subtitle:
                    'Track soil balance, nutrient health, and risk signals at a glance.',
              ),
              const SizedBox(height: 16),
              _SoilHealthOverviewCard(
                score: _healthScore(activeState),
                statusText: _healthStatusText(activeState),
                details: _healthDetails(activeState),
                anomalyCount: activeState.anomalyCount,
                outOfRangeCount: activeState.outOfRangeCount,
              ),
              const SizedBox(height: 18),
              _SectionTitle(
                title: 'Key Metrics',
                subtitle:
                    'Latest sensor averages with trend and ideal-range context.',
              ),
              const SizedBox(height: 10),
              _MetricWindowChips(
                selected: _metricWindow,
                onChanged: (value) => setState(() => _metricWindow = value),
              ),
              const SizedBox(height: 10),
              if (activeState.stats.isEmpty && !isLoading)
                StandardEmptyView(
                  title: l10n.emptyStatisticsTitle,
                  subtitle: l10n.emptyStatisticsSubtitle,
                  icon: Icons.query_stats_outlined,
                )
              else
                _buildStatGrid(context, activeState),
              const SizedBox(height: 18),
              _SectionTitle(
                title: 'Trend Visualizations',
                subtitle:
                    'Understand movement over time with clear axis and range selection.',
              ),
              const SizedBox(height: 8),
              _TimeRangeChips(
                selectedRange: _selectedRange,
                onChanged: (value) => setState(() => _selectedRange = value),
              ),
              if (filteredSamples.isNotEmpty) ...[
                const SizedBox(height: 10),
                _AnalyticsChartCard(
                  title: 'Moisture & pH Trend',
                  subtitle:
                      'Compares short-term moisture (%) and pH changes for the selected period.',
                  yAxisTitle: 'Value (% / pH)',
                  xAxisTitle: _xAxisTitleForRange(_selectedRange),
                  child: _buildHourlyChart(context, filteredSamples),
                ),
              ],
              if (filteredTrendPoints.isNotEmpty) ...[
                const SizedBox(height: 12),
                _AnalyticsChartCard(
                  title: 'Daily Moisture Signal',
                  subtitle:
                      'Daily moisture trend slope from backend trend table (positive = rising, negative = falling).',
                  yAxisTitle: 'Moisture slope',
                  xAxisTitle: 'Day',
                  legendItems: const [
                    _LegendItemData(
                      color: Color(0xFFB7791F),
                      label: 'Moisture slope',
                    ),
                  ],
                  child: _buildDailyTrendChart(context, filteredTrendPoints),
                ),
              ],
              const SizedBox(height: 18),
              _SectionTitle(
                title: 'Nutrient Insights',
                subtitle:
                    'Nitrogen, phosphorus, and potassium compared to practical targets.',
              ),
              const SizedBox(height: 10),
              _NutrientSection(stats: activeState.stats),
              const SizedBox(height: 14),
              _InsightBanner(
                title: _insightHeadline(activeState),
                message: _insightBody(activeState),
              ),
              const SizedBox(height: 8),
              _buildHealthSummary(context, activeState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatGrid(BuildContext context, StatisticsScreenState state) {
    final stats = state.stats;
    final points = _hourlyPointsForWindow(state.hourlyPoints, _metricWindow);
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.18,
      children: stats.map((s) => _buildStatCard(context, s, points)).toList(),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    SoilStatisticModel stat,
    List<DeviceTimeseriesPointResponse> windowPoints,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final average = _windowAverage(stat, windowPoints) ?? stat.value;
    final slope = _windowSlope(stat, windowPoints);
    final status = _metricStatus(stat, value: average);
    final trendIcon = _trendIconForSlope(slope);
    final trendColor = _trendColorForSlope(context, slope);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 9),
      decoration: BoxDecoration(
        color: AppTheme().cardSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _MetricIconChip(label: stat.label),
              const Spacer(),
              Icon(trendIcon, size: 18, color: trendColor),
            ],
          ),
          const Spacer(),
          Text(
            _valueWithUnit(stat, value: average),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 2),
          Text(
            _slopeLabel(stat, slope),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: trendColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _StatusBadge(
                text: status,
                color: _statusColor(context, status),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _idealHint(stat),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyChart(BuildContext context, List<SoilSampleModel> samples) {
    final colorScheme = Theme.of(context).colorScheme;
    final moistureSpots = <FlSpot>[];
    final phSpots = <FlSpot>[];
    final sorted = [...samples]
      ..sort((a, b) => a.collectedAt.compareTo(b.collectedAt));
    for (var i = 0; i < sorted.length; i++) {
      final item = sorted[i];
      moistureSpots.add(FlSpot(i.toDouble(), item.moisturePercent));
      phSpots.add(FlSpot(i.toDouble(), item.phLevel));
    }

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: 0,
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => colorScheme.onSurface.withAlpha(220),
              getTooltipItems: (spots) {
                return spots
                    .map(
                      (s) => LineTooltipItem(
                        '${s.barIndex == 0 ? "Moisture" : "pH"}: ${s.y.toStringAsFixed(1)}',
                        TextStyle(
                          color: colorScheme.surface,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    )
                    .toList();
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (_) => FlLine(
              color: colorScheme.outlineVariant.withAlpha(130),
              strokeWidth: 1,
              dashArray: [5, 4],
            ),
            getDrawingVerticalLine: (_) => FlLine(
              color: colorScheme.outlineVariant.withAlpha(90),
              strokeWidth: 1,
              dashArray: [5, 4],
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 35,
                color: colorScheme.primary.withAlpha(110),
                strokeWidth: 1.4,
                dashArray: [4, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                  labelResolver: (_) => 'Moisture target',
                ),
              ),
            ],
          ),
          lineBarsData: [
            LineChartBarData(
              spots: moistureSpots,
              isCurved: true,
              color: colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: colorScheme.primary.withAlpha(35),
              ),
            ),
            LineChartBarData(
              spots: phSpots,
              isCurved: true,
              color: AppTheme().info,
              barWidth: 2,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTrendChart(
    BuildContext context,
    List<DeviceTrendsDailyPoint> trendPoints,
  ) {
    final spots = <FlSpot>[];
    final sorted = [...trendPoints]
      ..sort((a, b) {
        final aa = a.dayTs ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bb = b.dayTs ?? DateTime.fromMillisecondsSinceEpoch(0);
        return aa.compareTo(bb);
      });
    for (var i = 0; i < sorted.length; i++) {
      final point = sorted[i];
      spots.add(FlSpot(i.toDouble(), point.slopeMoisture ?? 0));
    }

    final colorScheme = Theme.of(context).colorScheme;
    final maxAbsY = spots.isEmpty
        ? 1.0
        : spots
            .map((s) => s.y.abs())
            .reduce((a, b) => a > b ? a : b)
            .clamp(0.05, 5.0);
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: -maxAbsY,
          maxY: maxAbsY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (_) => FlLine(
              color: colorScheme.outlineVariant.withAlpha(110),
              strokeWidth: 1,
              dashArray: [5, 4],
            ),
            getDrawingVerticalLine: (_) => FlLine(
              color: colorScheme.outlineVariant.withAlpha(80),
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => colorScheme.onSurface.withAlpha(220),
              getTooltipItems: (spots) => spots
                  .map(
                    (e) => LineTooltipItem(
                      'Moisture slope ${e.y.toStringAsFixed(3)}',
                      TextStyle(color: colorScheme.surface, fontSize: 11),
                    ),
                  )
                  .toList(),
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) => Text(
                  _dayLabelForIndex(sorted, value.toInt()),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 0,
                color: colorScheme.onSurfaceVariant.withAlpha(140),
                strokeWidth: 1.2,
                dashArray: [4, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                  labelResolver: (_) => 'Stable (0)',
                ),
              ),
            ],
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppTheme().accent,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme().accent.withAlpha(28),
              ),
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSummary(BuildContext context, StatisticsScreenState state) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme().cardSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCounterTile(
              context,
              icon: Icons.warning_amber_rounded,
              label: 'Anomalies detected',
              value: state.anomalyCount.toString(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildCounterTile(
              context,
              icon: Icons.notification_important_outlined,
              label: 'Out-of-range events',
              value: state.outOfRangeCount.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  List<SoilSampleModel> _samplesForRange(List<SoilSampleModel> all) {
    if (all.isEmpty) {
      return const [];
    }
    final count = switch (_selectedRange) {
      _ChartRange.day => 4,
      _ChartRange.week => 8,
      _ChartRange.month => 16,
    };
    return all.length <= count ? all : all.sublist(all.length - count);
  }

  List<DeviceTrendsDailyPoint> _trendPointsForRange(List<DeviceTrendsDailyPoint> all) {
    if (all.isEmpty) {
      return const [];
    }
    final count = switch (_selectedRange) {
      _ChartRange.day => 4,
      _ChartRange.week => 7,
      _ChartRange.month => 14,
    };
    return all.length <= count ? all : all.sublist(all.length - count);
  }

  List<DeviceTimeseriesPointResponse> _hourlyPointsForWindow(
    List<DeviceTimeseriesPointResponse> all,
    _MetricWindow window,
  ) {
    if (all.isEmpty) return const [];
    final sorted = [...all]
      ..sort((a, b) {
        final aa = a.hourTs ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bb = b.hourTs ?? DateTime.fromMillisecondsSinceEpoch(0);
        return aa.compareTo(bb);
      });
    final count = switch (window) {
      _MetricWindow.today => 24,
      _MetricWindow.week => 24 * 7,
      _MetricWindow.month => 24 * 30,
    };
    return sorted.length <= count ? sorted : sorted.sublist(sorted.length - count);
  }

  double? _windowAverage(
    SoilStatisticModel stat,
    List<DeviceTimeseriesPointResponse> points,
  ) {
    if (points.isEmpty) return null;
    final values = _seriesForLabel(stat.label, points);
    if (values.isEmpty) return null;
    final sum = values.reduce((a, b) => a + b);
    return sum / values.length;
  }

  double? _windowSlope(
    SoilStatisticModel stat,
    List<DeviceTimeseriesPointResponse> points,
  ) {
    final values = _seriesForLabel(stat.label, points);
    if (values.length < 2) return null;
    final n = values.length.toDouble();
    var sumX = 0.0;
    var sumY = 0.0;
    var sumXY = 0.0;
    var sumXX = 0.0;
    for (var i = 0; i < values.length; i++) {
      final x = i.toDouble();
      final y = values[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumXX += x * x;
    }
    final denominator = n * sumXX - (sumX * sumX);
    if (denominator == 0) return 0;
    return (n * sumXY - (sumX * sumY)) / denominator;
  }

  List<double> _seriesForLabel(
    String label,
    List<DeviceTimeseriesPointResponse> points,
  ) {
    switch (label) {
      case 'Avg pH':
        return points
            .map((p) => p.avgPhValue)
            .whereType<double>()
            .toList(growable: false);
      case 'Avg Moisture':
        return points
            .map((p) => p.avgMoisture)
            .whereType<double>()
            .toList(growable: false);
      case 'Conductivity':
        return points
            .map((p) => p.avgConductivity)
            .whereType<double>()
            .toList(growable: false);
      default:
        return const [];
    }
  }

  IconData _trendIconForSlope(double? slope) {
    if (slope == null || slope == 0) return Icons.trending_flat_rounded;
    return slope > 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded;
  }

  Color _trendColorForSlope(BuildContext context, double? slope) {
    if (slope == null || slope == 0) return Theme.of(context).colorScheme.secondary;
    return slope > 0 ? AppTheme().success : AppTheme().error;
  }

  String _slopeLabel(SoilStatisticModel stat, double? slope) {
    final windowLabel = switch (_metricWindow) {
      _MetricWindow.today => '24h',
      _MetricWindow.week => '7d',
      _MetricWindow.month => '30d',
    };
    if (slope == null) return 'Slope ($windowLabel): unavailable';
    final sign = slope > 0 ? '+' : '';
    final precision = stat.label == 'Avg pH' ? 3 : 2;
    final unit = stat.unit.isEmpty ? '' : ' ${stat.unit}';
    return 'Slope ($windowLabel): $sign${slope.toStringAsFixed(precision)}$unit /hr';
  }

  int _healthScore(StatisticsScreenState state) {
    final statsMap = {for (final s in state.stats) s.label: s.value};
    final ph = _scoreByRange(statsMap['Avg pH'] ?? 0, 6.0, 7.4);
    final moisture = _scoreByRange(statsMap['Avg Moisture'] ?? 0, 30, 60);
    final conductivity = _scoreByRange(statsMap['Conductivity'] ?? 0, 500, 2200);
    final nutrients = [
      _scoreByRange(statsMap['Nitrogen'] ?? 0, 20, 50),
      _scoreByRange(statsMap['Phosphorus'] ?? 0, 15, 40),
      _scoreByRange(statsMap['Potassium'] ?? 0, 20, 60),
    ].reduce((a, b) => a + b) /
        3;

    var score = ((ph + moisture + conductivity + nutrients) / 4).round();
    score -= (state.anomalyCount * 3).clamp(0, 20);
    score -= (state.outOfRangeCount * 2).clamp(0, 20);
    return score.clamp(0, 100);
  }

  int _scoreByRange(double value, double min, double max) {
    if (value >= min && value <= max) return 100;
    final distance = value < min ? (min - value) : (value - max);
    final spread = (max - min).abs().clamp(1, 10000);
    final penalty = ((distance / spread) * 100).round();
    return (100 - penalty).clamp(0, 100);
  }

  String _healthStatusText(StatisticsScreenState state) {
    final score = _healthScore(state);
    if (score >= 80) return 'Healthy and stable';
    if (score >= 60) return 'Needs attention';
    return 'Action recommended';
  }

  String _healthDetails(StatisticsScreenState state) {
    if (state.anomalyCount > 0) {
      return 'Detected ${state.anomalyCount} anomaly signals. Review trend cards below.';
    }
    if (state.outOfRangeCount > 0) {
      return 'Some readings are outside target thresholds.';
    }
    return 'Most key soil indicators are inside recommended ranges.';
  }

  String _metricStatus(SoilStatisticModel stat, {double? value}) {
    final ranges = _idealRange(stat.label);
    if (ranges == null) return 'No target';
    final v = value ?? stat.value;
    if (v < ranges.$1) return 'Low';
    if (v > ranges.$2) return 'High';
    return 'Healthy';
  }

  (double, double)? _idealRange(String label) {
    switch (label) {
      case 'Avg pH':
        return (6.0, 7.4);
      case 'Avg Moisture':
        return (30, 60);
      case 'Conductivity':
        return (500, 2200);
      case 'Nitrogen':
        return (20, 50);
      case 'Phosphorus':
        return (15, 40);
      case 'Potassium':
        return (20, 60);
      default:
        return null;
    }
  }

  String _idealHint(SoilStatisticModel stat) {
    final range = _idealRange(stat.label);
    if (range == null) return 'No reference range';
    final unit = stat.unit.isNotEmpty ? stat.unit : '';
    return 'Ideal: ${range.$1.toStringAsFixed(0)}-${range.$2.toStringAsFixed(0)} $unit'
        .trim();
  }

  String _valueWithUnit(SoilStatisticModel stat, {double? value}) {
    final numeric = value ?? stat.value;
    final precision = numeric % 1 == 0 ? 0 : 1;
    final valueText = numeric.toStringAsFixed(precision);
    return stat.unit.isEmpty ? valueText : '$valueText ${stat.unit}';
  }

  Color _statusColor(BuildContext context, String status) {
    final scheme = Theme.of(context).colorScheme;
    switch (status) {
      case 'Healthy':
        return AppTheme().success;
      case 'Low':
      case 'High':
        return AppTheme().warning;
      default:
        return scheme.secondary;
    }
  }

  String _xAxisTitleForRange(_ChartRange range) {
    return switch (range) {
      _ChartRange.day => 'Recent samples (hours)',
      _ChartRange.week => 'Samples across week',
      _ChartRange.month => 'Samples across two weeks',
    };
  }

  String _insightHeadline(StatisticsScreenState state) {
    if (state.anomalyCount > 0) {
      return 'Moisture volatility detected';
    }
    final moisture = state.stats
        .where((e) => e.label == 'Avg Moisture')
        .map((e) => e.value)
        .firstOrNull;
    if (moisture != null && moisture < 30) {
      return 'Moisture slightly below ideal';
    }
    return 'pH and nutrients are mostly balanced';
  }

  String _insightBody(StatisticsScreenState state) {
    if (state.anomalyCount > 0) {
      return 'Sensor signals show unusual movement. Consider checking irrigation schedule and device placement.';
    }
    if (state.outOfRangeCount > 0) {
      return 'Some values are outside expected ranges. Prioritize fields with repeated out-of-range events.';
    }
    return 'Current trend is stable. Continue monitoring daily moisture and weekly nutrient drift.';
  }

  String _dayLabelForIndex(List<DeviceTrendsDailyPoint> points, int index) {
    if (index < 0 || index >= points.length) return '';
    final dt = points[index].dayTs;
    if (dt == null) return index.toString();
    return '${dt.day}';
  }
}

enum _ChartRange { day, week, month }

enum _MetricWindow { today, week, month }

class _StatisticsHeader extends StatelessWidget {
  const _StatisticsHeader({required this.title, required this.subtitle});

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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 2),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _SoilHealthOverviewCard extends StatelessWidget {
  const _SoilHealthOverviewCard({
    required this.score,
    required this.statusText,
    required this.details,
    required this.anomalyCount,
    required this.outOfRangeCount,
  });

  final int score;
  final String statusText;
  final String details;
  final int anomalyCount;
  final int outOfRangeCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appTheme = AppTheme();
    final indicatorColor = score >= 80
        ? appTheme.success
        : score >= 60
            ? appTheme.warning
            : appTheme.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withAlpha(30),
            scheme.secondary.withAlpha(28),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Soil Health Overview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: indicatorColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 74,
                height: 74,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: indicatorColor.withAlpha(24),
                  border: Border.all(color: indicatorColor.withAlpha(110)),
                ),
                child: Text(
                  '$score',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: indicatorColor,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(details, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatusBadge(
                text: '$anomalyCount anomalies',
                color: anomalyCount > 0 ? appTheme.warning : appTheme.success,
              ),
              const SizedBox(width: 8),
              _StatusBadge(
                text: '$outOfRangeCount out-of-range',
                color: outOfRangeCount > 0 ? appTheme.warning : appTheme.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeRangeChips extends StatelessWidget {
  const _TimeRangeChips({
    required this.selectedRange,
    required this.onChanged,
  });

  final _ChartRange selectedRange;
  final ValueChanged<_ChartRange> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        _chip(context, _ChartRange.day, '24H'),
        _chip(context, _ChartRange.week, '7D'),
        _chip(context, _ChartRange.month, '14D'),
      ],
    );
  }

  Widget _chip(BuildContext context, _ChartRange value, String label) {
    final selected = value == selectedRange;
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      selected: selected,
      label: Text(label),
      onSelected: (_) => onChanged(value),
      selectedColor: scheme.primary.withAlpha(26),
      side: BorderSide(
        color: selected ? scheme.primary.withAlpha(120) : scheme.outlineVariant,
      ),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
    );
  }
}

class _MetricWindowChips extends StatelessWidget {
  const _MetricWindowChips({
    required this.selected,
    required this.onChanged,
  });

  final _MetricWindow selected;
  final ValueChanged<_MetricWindow> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        _chip(context, _MetricWindow.today, 'Today'),
        _chip(context, _MetricWindow.week, 'This Week'),
        _chip(context, _MetricWindow.month, 'This Month'),
      ],
    );
  }

  Widget _chip(BuildContext context, _MetricWindow value, String label) {
    final selectedChip = value == selected;
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      selected: selectedChip,
      label: Text(label),
      onSelected: (_) => onChanged(value),
      selectedColor: scheme.primary.withAlpha(26),
      side: BorderSide(
        color: selectedChip
            ? scheme.primary.withAlpha(120)
            : scheme.outlineVariant,
      ),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: selectedChip ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: selectedChip ? FontWeight.w700 : FontWeight.w500,
          ),
    );
  }
}

class _AnalyticsChartCard extends StatelessWidget {
  const _AnalyticsChartCard({
    required this.title,
    required this.subtitle,
    required this.yAxisTitle,
    required this.xAxisTitle,
    required this.child,
    this.legendItems,
  });

  final String title;
  final String subtitle;
  final String yAxisTitle;
  final String xAxisTitle;
  final Widget child;
  final List<_LegendItemData>? legendItems;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: AppTheme().cardSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.straighten_rounded, size: 14, color: scheme.primary),
              const SizedBox(width: 4),
              Text(
                'Y-axis: $yAxisTitle',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 14, color: scheme.secondary),
              const SizedBox(width: 4),
              Text(
                'X-axis: $xAxisTitle',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
          const SizedBox(height: 8),
          Row(
            children: (legendItems ??
                    const [
                      _LegendItemData(
                        color: Color(0xFF2D6A4F),
                        label: 'Moisture',
                      ),
                      _LegendItemData(
                        color: Color(0xFF2B7A78),
                        label: 'pH / reference',
                      ),
                    ])
                .map((item) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _LegendDot(color: item.color, label: item.label),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LegendItemData {
  const _LegendItemData({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;
}

class _NutrientSection extends StatelessWidget {
  const _NutrientSection({required this.stats});

  final List<SoilStatisticModel> stats;

  @override
  Widget build(BuildContext context) {
    final nutrientStats = stats
        .where(
          (e) =>
              e.label == 'Nitrogen' ||
              e.label == 'Phosphorus' ||
              e.label == 'Potassium',
        )
        .toList();
    return Column(
      children: nutrientStats
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _NutrientInsightCard(stat: e),
            ),
          )
          .toList(),
    );
  }
}

class _NutrientInsightCard extends StatelessWidget {
  const _NutrientInsightCard({required this.stat});

  final SoilStatisticModel stat;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final range = switch (stat.label) {
      'Nitrogen' => (20.0, 50.0),
      'Phosphorus' => (15.0, 40.0),
      'Potassium' => (20.0, 60.0),
      _ => (0.0, 1.0),
    };
    final status = stat.value < range.$1
        ? 'Low'
        : stat.value > range.$2
            ? 'High'
            : 'Healthy';
    final progress =
        ((stat.value - range.$1) / (range.$2 - range.$1)).clamp(0.0, 1.0);
    final color = status == 'Healthy'
        ? AppTheme().success
        : status == 'Low'
            ? scheme.secondary
            : AppTheme().warning;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme().cardSurface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.eco_rounded, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(stat.label, style: Theme.of(context).textTheme.titleSmall),
              ),
              Text(
                '${stat.value.toStringAsFixed(1)} ${stat.unit}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(12),
            backgroundColor: scheme.outlineVariant.withAlpha(120),
            valueColor: AlwaysStoppedAnimation(color),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _StatusBadge(text: status, color: color),
              const SizedBox(width: 8),
              Text(
                'Target ${range.$1.toStringAsFixed(0)}-${range.$2.toStringAsFixed(0)} ${stat.unit}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightBanner extends StatelessWidget {
  const _InsightBanner({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primary.withAlpha(22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.primary.withAlpha(70)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.tips_and_updates_outlined, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricIconChip extends StatelessWidget {
  const _MetricIconChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final icon = switch (label) {
      'Avg pH' => Icons.bubble_chart_rounded,
      'Avg Moisture' => Icons.water_drop_rounded,
      'Conductivity' => Icons.bolt_rounded,
      'Nitrogen' => Icons.spa_rounded,
      'Phosphorus' => Icons.scatter_plot_rounded,
      'Potassium' => Icons.grass_rounded,
      _ => Icons.analytics_rounded,
    };
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});

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

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
