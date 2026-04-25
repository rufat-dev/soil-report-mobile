import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:soilreport/src/common_widgets/standard_empty_view.dart';
import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/features/alerts/domain/soil_alert_model.dart';
import 'package:soilreport/src/features/alerts/presentation/alerts_screen_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(alertsScreenControllerProvider.notifier).loadAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(alertsScreenControllerProvider);
    final activeState = ref
        .read(alertsScreenControllerProvider.notifier)
        .effectiveState;
    final isLoading = activeState.checkState.isNullOrLoading;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 100.sw(context),
      color: colorScheme.surface,
      child: RefreshIndicator(
        color: colorScheme.primary,
        onRefresh: () =>
            ref.read(alertsScreenControllerProvider.notifier).loadAlerts(),
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
                l10n.tab2Title,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              if (activeState.alerts.isEmpty && !isLoading)
                StandardEmptyView(
                  title: l10n.emptyAlertsTitle,
                  subtitle: l10n.emptyAlertsSubtitle,
                  icon: Icons.notifications_none_outlined,
                ),
              ...activeState.alerts.isEmpty && isLoading
                  ? List.generate(4, (_) => _buildAlertCardSkeleton(context))
                  : activeState.alerts.map((a) => _buildAlertCard(context, a)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, SoilAlertModel alert) {
    final severityColor = switch (alert.severity) {
      SoilAlertSeverity.critical => AppTheme().error,
      SoilAlertSeverity.warning => AppTheme().warning,
      SoilAlertSeverity.info => AppTheme().info,
    };
    return Dismissible(
      key: ValueKey(alert.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          ref.read(alertsScreenControllerProvider.notifier).dismissAlert(alert.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme().error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          if (!alert.isRead) {
            ref
                .read(alertsScreenControllerProvider.notifier)
                .markAsRead(alert.id);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme().cardSurface(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: alert.isRead
                  ? Theme.of(context).colorScheme.outlineVariant
                  : severityColor.withAlpha(60),
              width: alert.isRead ? 1 : 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(alert.title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(
                alert.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCardSkeleton(BuildContext context) {
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
        child: SizedBox(height: 80, width: double.infinity),
      ),
    );
  }
}
