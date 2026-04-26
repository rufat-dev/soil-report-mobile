import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soilreport/src/common_widgets/primary_button.dart';
import 'package:soilreport/src/features/home/domain/dashboard_device_model.dart';
import 'package:soilreport/src/features/statistics/domain/soil_statistic_model.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/routing/app_router.dart';
import 'package:soilreport/src/utils/app_theme.dart';

class DashboardDevicesSection extends StatelessWidget {
  const DashboardDevicesSection({
    super.key,
    required this.devices,
    required this.groups,
    required this.latestStateByDeviceId,
    required this.attentionDeviceIds,
  });

  final List<DashboardDeviceModel> devices;
  final List<DeviceGroupModel> groups;
  final Map<String, DeviceStateLatestResponse> latestStateByDeviceId;
  final List<String> attentionDeviceIds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dashboardDevicesSectionTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        if (devices.isEmpty)
          _buildEmptyCard(context)
        else ...[
          ...devices.map((device) => _buildDeviceCard(context, device)),
          const SizedBox(height: 8),
          PrimaryButton(
            text: l10n.dashboardDevicesAddButton,
            onPressed: () => context.pushNamed(AppRoute.addDevice.name),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppTheme().appCardDecoration(context, borderRadius: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashboardDevicesEmptyTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.dashboardDevicesEmptySubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            text: l10n.dashboardDevicesAddButton,
            onPressed: () => context.pushNamed(AppRoute.addDevice.name),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context, DashboardDeviceModel device) {
    final colorScheme = Theme.of(context).colorScheme;
    final latest = latestStateByDeviceId[device.deviceId];
    final status = _statusLabel(device.operationalStatus);
    final groupName = groups
        .where((g) => g.groupId == device.groupId)
        .map((g) => g.groupName?.trim().isNotEmpty == true ? g.groupName! : g.groupId)
        .firstWhere((_) => true, orElse: () => 'Ungrouped');
    final needsAttention = attentionDeviceIds.contains(device.deviceId);
    final statusColor = needsAttention ? AppTheme().warning : AppTheme().success;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: AppTheme().appCardDecoration(
        context,
        borderRadius: 14,
        borderColor: needsAttention
            ? statusColor.withAlpha(120)
            : AppTheme().cardBorderColor(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  device.deviceName?.trim().isNotEmpty == true
                      ? device.deviceName!
                      : device.deviceId,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: statusColor.withAlpha(90)),
                ),
                child: Text(
                  needsAttention ? 'Needs attention' : 'Stable',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(device.deviceId, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(
                context,
                icon: Icons.folder_outlined,
                label: groupName,
                color: colorScheme.primary,
              ),
              _chip(
                context,
                icon: Icons.settings_suggest_outlined,
                label: status,
                color: colorScheme.secondary,
              ),
            ],
          ),
          if (latest != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                _miniMetric(context, 'pH', _formatNum(latest.phValue)),
                _miniMetric(
                  context,
                  'Moisture',
                  '${_formatNum(latest.moisture)}%',
                ),
                _miniMetric(
                  context,
                  'Cond.',
                  '${_formatNum(latest.conductivity)} uS/cm',
                ),
              ],
            ),
          ],
          if (device.locationNotes?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              device.locationNotes!,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _miniMetric(BuildContext context, String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withAlpha(120),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelSmall),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _formatNum(double? value) {
    if (value == null) return '-';
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
  }

  String _statusLabel(int? status) {
    switch (status) {
      case 1:
        return 'Operational / Reading';
      case 2:
        return 'Charging';
      case 3:
        return 'Not responding';
      default:
        return 'Unknown';
    }
  }
}
