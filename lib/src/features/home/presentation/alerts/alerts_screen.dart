import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/features/home/domain/alerts/soil_alert_model.dart';
import 'package:soilreport/src/features/home/presentation/alerts/alerts_screen_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    final activeState =
        ref.read(alertsScreenControllerProvider.notifier).effectiveState;
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
                l10n.tab2Title,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 6),
              if (!isLoading)
                Text(
                  l10n.alertsActiveCount(
                      activeState.alerts.where((a) => !a.isRead).length),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(height: 16),
              ...activeState.alerts.isEmpty && isLoading
                  ? List.generate(
                      4, (_) => _buildAlertCardSkeleton(context))
                  : activeState.alerts
                      .map((a) => _buildAlertCard(context, a)),
              if (activeState.alerts.isEmpty && !isLoading)
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
                          child: Icon(Icons.check_circle_outline,
                              size: 48, color: AppTheme().success),
                        ),
                        const SizedBox(height: 16),
                        Text(l10n.alertsNoAlerts,
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

  Widget _buildAlertCard(BuildContext context, SoilAlertModel alert) {
    final colorScheme = Theme.of(context).colorScheme;
    final severityColor = switch (alert.severity) {
      SoilAlertSeverity.critical => AppTheme().error,
      SoilAlertSeverity.warning => AppTheme().warning,
      SoilAlertSeverity.info => AppTheme().info,
    };
    final severityIcon = switch (alert.severity) {
      SoilAlertSeverity.critical => Icons.error_rounded,
      SoilAlertSeverity.warning => Icons.warning_amber_rounded,
      SoilAlertSeverity.info => Icons.info_outline_rounded,
    };

    return Dismissible(
      key: ValueKey(alert.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => ref
          .read(alertsScreenControllerProvider.notifier)
          .dismissAlert(alert.id),
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
                  ? colorScheme.outlineVariant
                  : severityColor.withAlpha(60),
              width: alert.isRead ? 1 : 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: severityColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(severityIcon, color: severityColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alert.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: alert.isRead
                                      ? FontWeight.w400
                                      : FontWeight.w600,
                                ),
                          ),
                        ),
                        if (!alert.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: severityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(alert.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 13, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(alert.siteLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(fontSize: 10)),
                        ),
                        Text(_formatTime(alert.createdAt),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
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
            color: Theme.of(context).colorScheme.outlineVariant, width: 1),
      ),
      child: const Skeleton.leaf(
          child: SizedBox(height: 80, width: double.infinity)),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
