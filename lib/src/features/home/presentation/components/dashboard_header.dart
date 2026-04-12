import 'package:soilreport/src/features/home/presentation/dashboard_screen/dashboard_screen_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/app_router.dart';
import '../../../authentication/data/auth_repository.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateChangesProvider).value;
    ref.watch(dashboardScreenControllerProvider);
    final isRealScope = ref
        .read(dashboardScreenControllerProvider.notifier)
        .effectiveState
        .isRealScope;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        GestureDetector(
          onTap: isRealScope
              ? () => context.pushNamed(AppRoute.profile.name)
              : null,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
              border: Border.all(
                color: colorScheme.primary.withAlpha(40),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                currentUser?.name?.isNotEmpty == true
                    ? currentUser!.name!.substring(0, 1).toUpperCase()
                    : '?',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    l10n.dashboardPageHi,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      '${currentUser?.name ?? ''},',
                      style: Theme.of(context).textTheme.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                l10n.dashboardPageWelcome,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildIconButton(
          context,
          icon: Icons.notifications_outlined,
          onTap: () => context.pushNamed(AppRoute.notifications.name),
        ),
        const SizedBox(width: 4),
        _buildIconButton(
          context,
          icon: Icons.menu_rounded,
          onTap: () => context.pushNamed(AppRoute.menu.name),
        ),
      ],
    );
  }

  Widget _buildIconButton(BuildContext context,
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme().elevatedSurface(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 22,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
