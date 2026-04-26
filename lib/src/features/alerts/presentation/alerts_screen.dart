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
    final alerts = activeState.alerts;
    final unread = alerts.where((a) => !a.isRead).toList();
    final read = alerts.where((a) => a.isRead).toList();

    return Container(
      width: 100.sw(context),
      color: colorScheme.surface,
      child: RefreshIndicator(
        color: colorScheme.primary,
        onRefresh: () => ref
            .read(alertsScreenControllerProvider.notifier)
            .loadAlerts(forceRemote: true),
        child: Skeletonizer(
          enabled: isLoading,
          effect: AppTheme().skeletonPulseEffect(context),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.only(
              top: 100.devicePaddingTop(context) + 15,
              left: 16,
              right: 16,
              bottom: 24,
            ),
            children: [
              _AlertsHeader(
                title: l10n.tab2Title,
                subtitle:
                    'Push and system notifications in one place. Swipe right on a row to remove it.',
              ),
              const SizedBox(height: 14),
              if (!isLoading)
                _AlertsSummaryStrip(
                  unreadCount: unread.length,
                  totalCount: alerts.length,
                ),
              if (!isLoading) const SizedBox(height: 14),
              if (activeState.hasLoadError && !isLoading && alerts.isEmpty)
                _AlertsErrorCard(
                  onRetry: () =>
                      ref
                          .read(alertsScreenControllerProvider.notifier)
                          .loadAlerts(forceRemote: true),
                )
              else if (alerts.isEmpty && !isLoading)
                StandardEmptyView(
                  title: l10n.emptyAlertsTitle,
                  subtitle:
                      'You have no notifications yet. Alerts from the app and AI insights will appear here.',
                  icon: Icons.notifications_none_outlined,
                ),
              if (isLoading) ...[
                ...List.generate(4, (_) => _alertTileSkeleton(context)),
              ] else ...[
                if (unread.isNotEmpty) ...[
                  _SectionTitle(
                    title: 'Needs attention',
                    subtitle: '${unread.length} unread',
                  ),
                  ...unread.map(
                    (a) => _AlertInboxTile(
                      alert: a,
                      onTap: () => _openAlertDetail(context, a),
                      onDismissed: () => ref
                          .read(alertsScreenControllerProvider.notifier)
                          .dismissAlert(a.id),
                    ),
                  ),
                ],
                if (read.isNotEmpty) ...[
                  if (unread.isNotEmpty) const SizedBox(height: 8),
                  _SectionTitle(
                    title: unread.isEmpty ? 'Inbox' : 'Earlier',
                    subtitle: unread.isEmpty
                        ? '${read.length} notification${read.length == 1 ? '' : 's'}'
                        : '${read.length} read',
                  ),
                  ...read.map(
                    (a) => _AlertInboxTile(
                      alert: a,
                      onTap: () => _openAlertDetail(context, a),
                      onDismissed: () => ref
                          .read(alertsScreenControllerProvider.notifier)
                          .dismissAlert(a.id),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAlertDetail(BuildContext context, SoilAlertModel alert) async {
    if (!alert.isRead) {
      await ref.read(alertsScreenControllerProvider.notifier).markAsRead(alert.id);
    }
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AlertDetailSheet(alert: alert),
    );
  }
}

class _AlertsHeader extends StatelessWidget {
  const _AlertsHeader({required this.title, required this.subtitle});

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

class _AlertsSummaryStrip extends StatelessWidget {
  const _AlertsSummaryStrip({
    required this.unreadCount,
    required this.totalCount,
  });

  final int unreadCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppTheme().appCardDecoration(context, borderRadius: 14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _SummaryChip(
            label: '$unreadCount unread',
            color: unreadCount > 0 ? AppTheme().error : AppTheme().success,
            icon: Icons.mark_email_unread_outlined,
          ),
          _SummaryChip(
            label: '$totalCount total',
            color: scheme.primary,
            icon: Icons.notifications_active_outlined,
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _AlertsErrorCard extends StatelessWidget {
  const _AlertsErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme().appCardDecoration(context, borderRadius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Could not load alerts',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Check your connection or session, then try again.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _AlertInboxTile extends StatelessWidget {
  const _AlertInboxTile({
    required this.alert,
    required this.onTap,
    required this.onDismissed,
  });

  final SoilAlertModel alert;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final severityColor = switch (alert.severity) {
      SoilAlertSeverity.critical => AppTheme().error,
      SoilAlertSeverity.warning => AppTheme().warning,
      SoilAlertSeverity.info => scheme.primary,
    };
    final severityLabel = switch (alert.severity) {
      SoilAlertSeverity.critical => 'Urgent',
      SoilAlertSeverity.warning => 'Warning',
      SoilAlertSeverity.info => 'Info',
    };

    return Dismissible(
      key: ValueKey(alert.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => onDismissed(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme().error.withAlpha(220),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Text(
              'Remove',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
            decoration: AppTheme().appCardDecoration(
              context,
              borderRadius: 14,
              borderColor: alert.isRead
                  ? AppTheme().cardBorderColor(context)
                  : severityColor.withAlpha(100),
              borderWidth: alert.isRead ? 1 : 1.4,
              boxShadow: [
                ...AppTheme().cardAmbientShadows(context),
                if (!alert.isRead)
                  BoxShadow(
                    color: severityColor.withAlpha(24),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!alert.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    decoration: BoxDecoration(
                      color: severityColor,
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              alert.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: alert.isRead
                                        ? scheme.onSurfaceVariant
                                        : scheme.onSurface,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _recencyLabel(alert.createdAt),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: scheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _preview(alert.description),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.25,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _MetaChip(
                            icon: Icons.devices_other_rounded,
                            label: alert.siteLabel,
                            color: scheme.secondary,
                          ),
                          _MetaChip(
                            icon: Icons.flag_outlined,
                            label: severityLabel,
                            color: severityColor,
                          ),
                          if (!alert.isRead)
                            _MetaChip(
                              icon: Icons.circle_outlined,
                              label: 'Unread',
                              color: scheme.primary,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 4),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: scheme.outline,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _preview(String text) {
    final t = text.trim();
    if (t.isEmpty) return 'No additional details.';
    return t;
  }

  static String _recencyLabel(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${createdAt.day}/${createdAt.month}';
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _alertTileSkeleton(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: AppTheme().appCardDecoration(context, borderRadius: 14),
    child: const Skeleton.leaf(
      child: SizedBox(height: 88, width: double.infinity),
    ),
  );
}

class _AlertDetailSheet extends StatelessWidget {
  const _AlertDetailSheet({required this.alert});

  final SoilAlertModel alert;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final severityColor = switch (alert.severity) {
      SoilAlertSeverity.critical => AppTheme().error,
      SoilAlertSeverity.warning => AppTheme().warning,
      SoilAlertSeverity.info => scheme.primary,
    };
    final severityLabel = switch (alert.severity) {
      SoilAlertSeverity.critical => 'Urgent',
      SoilAlertSeverity.warning => 'Warning',
      SoilAlertSeverity.info => 'Informational',
    };

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20 + MediaQuery.paddingOf(context).bottom,
        top: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  alert.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withAlpha(22),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: severityColor.withAlpha(80)),
                ),
                child: Text(
                  severityLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: severityColor,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatFullTimestamp(alert.createdAt),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.devices_other_rounded, size: 18, color: scheme.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  alert.siteLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Message',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.42,
            ),
            child: SingleChildScrollView(
              child: Text(
                alert.description.isEmpty ? 'No message body.' : alert.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatFullTimestamp(DateTime dt) {
    final local = dt.toLocal();
    final d = local;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
