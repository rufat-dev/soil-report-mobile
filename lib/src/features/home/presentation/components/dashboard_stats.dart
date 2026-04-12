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
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

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
          _stat(context,
              icon: Icons.timeline_rounded,
              iconColor: AppTheme().teal,
              value: '0',
              label: l10n.dashboardPagePeriodCount),
          _verticalDivider(context),
          _stat(context,
              icon: Icons.description_outlined,
              iconColor: colorScheme.primary,
              value: '0',
              label: l10n.dashboardPagePolicies),
          _verticalDivider(context),
          _stat(context,
              icon: Icons.verified_outlined,
              iconColor: AppTheme().success,
              value: '0',
              label: l10n.dashboardPageNoClaimsDaysCount),
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
