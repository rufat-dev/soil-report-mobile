import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soilreport/src/common_widgets/primary_button.dart';
import 'package:soilreport/src/features/home/domain/dashboard_device_model.dart';
import 'package:soilreport/src/features/home/presentation/dashboard_screen/dashboard_screen_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/routing/app_router.dart';
import 'package:soilreport/src/utils/app_theme.dart';

class DashboardGroupsSection extends ConsumerWidget {
  const DashboardGroupsSection({
    super.key,
    required this.groups,
    required this.devices,
    required this.attentionDeviceIds,
  });

  final List<DeviceGroupModel> groups;
  final List<DashboardDeviceModel> devices;
  final List<String> attentionDeviceIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dashboardGroupsSectionTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        if (groups.isEmpty)
          _buildEmptyCard(context, ref)
        else ...[
          ...groups.map((group) => _buildGroupCard(context, group)),
          const SizedBox(height: 8),
          PrimaryButton(
            text: l10n.dashboardGroupsAddButton,
            onPressed: () => _openAddGroup(context, ref),
          ),
        ],
      ],
    );
  }

  Future<void> _openAddGroup(BuildContext context, WidgetRef ref) async {
    final created = await context.pushNamed<bool>(AppRoute.addGroup.name);
    if (created == true && context.mounted) {
      await ref
          .read(dashboardScreenControllerProvider.notifier)
          .loadScreen(useCache: false);
    }
  }

  Widget _buildEmptyCard(BuildContext context, WidgetRef ref) {
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
            l10n.dashboardGroupsEmptyTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.dashboardGroupsEmptySubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            text: l10n.dashboardGroupsAddButton,
            onPressed: () => _openAddGroup(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, DeviceGroupModel group) {
    final colorScheme = Theme.of(context).colorScheme;
    final title = group.groupName?.trim().isNotEmpty == true
        ? group.groupName!
        : group.groupId;
    final deviceCount = devices.where((d) => d.groupId == group.groupId).length;
    final attentionCount = devices
        .where((d) => d.groupId == group.groupId)
        .where((d) => attentionDeviceIds.contains(d.deviceId))
        .length;
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
          Row(
            children: [
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleSmall)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$deviceCount device${deviceCount == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(group.groupId, style: Theme.of(context).textTheme.bodySmall),
          if (attentionCount > 0) ...[
            const SizedBox(height: 6),
            Text(
              '$attentionCount device${attentionCount == 1 ? '' : 's'} need attention',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme().warning,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
          if (group.notes?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(group.notes!, style: Theme.of(context).textTheme.labelSmall),
          ],
        ],
      ),
    );
  }
}
