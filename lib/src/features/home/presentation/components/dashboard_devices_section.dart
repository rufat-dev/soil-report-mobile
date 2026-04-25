import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soilreport/src/common_widgets/primary_button.dart';
import 'package:soilreport/src/features/home/domain/dashboard_device_model.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/routing/app_router.dart';
import 'package:soilreport/src/utils/app_theme.dart';

class DashboardDevicesSection extends StatelessWidget {
  const DashboardDevicesSection({super.key, required this.devices});

  final List<DashboardDeviceModel> devices;

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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme().cardSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme().cardSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device.deviceName?.trim().isNotEmpty == true
                ? device.deviceName!
                : device.deviceId,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(device.deviceId, style: Theme.of(context).textTheme.bodySmall),
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
}
