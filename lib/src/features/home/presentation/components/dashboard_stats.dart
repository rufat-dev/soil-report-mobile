import 'package:soilreport/src/features/home/presentation/dashboard_screen/dashboard_screen_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardStats extends ConsumerWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dashboardScreenControllerProvider);
    final notifier = ref.read(dashboardScreenControllerProvider.notifier);
    final activeState = notifier.effectiveState;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    // Use notifier loading flag: [effectiveState] swaps in mockState when real
    // checkState is null, and that mock state uses data(null) so it looks "loaded".
    final isLoading = notifier.isEffectiveLoading;
    final deviceCount = activeState.devices.length;
    final groupCount = activeState.groups.length;
    final attentionCount = activeState.attentionDeviceIds.length;
    final healthyCount = (deviceCount - attentionCount).clamp(0, deviceCount);
    final chargingCount =
        activeState.devices.where((d) => d.operationalStatus == 2).length;
    final subtitle = isLoading
        ? 'Syncing latest dashboard facts...'
        : attentionCount > 0
            ? '$attentionCount device${attentionCount == 1 ? '' : 's'} currently need review.'
            : 'All visible devices look stable right now.';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme().cardSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operational Overview',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Row(
            children: [
              _stat(
                context,
                icon: Icons.devices_other_outlined,
                iconColor: AppTheme().teal,
                value: isLoading ? '—' : '$deviceCount',
                label: l10n.dashboardStatDevicesLabel,
              ),
              _verticalDivider(context),
              _stat(
                context,
                icon: Icons.folder_copy_outlined,
                iconColor: colorScheme.primary,
                value: isLoading ? '—' : '$groupCount',
                label: l10n.dashboardStatGroupsLabel,
              ),
              _verticalDivider(context),
              _stat(
                context,
                icon: Icons.health_and_safety_outlined,
                iconColor: AppTheme().success,
                value: isLoading ? '—' : '$healthyCount',
                label: 'Healthy',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statusChip(
                context,
                label: attentionCount == 0
                    ? 'No immediate alerts'
                    : '$attentionCount needs attention',
                color: attentionCount == 0 ? AppTheme().success : AppTheme().warning,
              ),
              if (chargingCount > 0 ||
                  activeState.devices.where((d) => d.operationalStatus == 3).isNotEmpty)
                _statusChip(
                  context,
                  label:
                      '$chargingCount charging, ${activeState.devices.where((d) => d.operationalStatus == 3).length} not responding',
                  color: colorScheme.secondary,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context,
      {required IconData icon,
      required Color iconColor,
      required String value,
      required String label}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Column(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDivider(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }

  Widget _statusChip(
    BuildContext context, {
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        border: Border.all(color: color.withAlpha(70)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
