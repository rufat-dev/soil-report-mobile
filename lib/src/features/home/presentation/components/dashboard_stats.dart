import 'package:soilreport/src/features/home/presentation/dashboard_screen/dashboard_screen_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardStats extends ConsumerWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dashboardScreenControllerProvider);
    final activeState = ref
        .read(dashboardScreenControllerProvider.notifier)
        .effectiveState;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = activeState.checkState.isNullOrLoading;
    final deviceCount = activeState.devices.length;
    final groupCount = activeState.groups.length;
    final statusCatalogCount = activeState.operationStatuses.length;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme().cardSurface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
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
            icon: Icons.assignment_turned_in_outlined,
            iconColor: AppTheme().success,
            value: isLoading ? '—' : '$statusCatalogCount',
            label: l10n.dashboardStatOperationStatusesLabel,
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
}
