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
    final state = ref
        .read(dashboardScreenControllerProvider.notifier)
        .effectiveState;
    final isRealScope = state.isRealScope;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final displayName = currentUser?.fullName?.trim().isNotEmpty == true
        ? currentUser!.fullName!.trim()
        : (currentUser?.name?.trim().isNotEmpty == true
            ? currentUser!.name!.trim()
            : null);
    final initials = _initialsFromUser(currentUser?.fullName, currentUser?.email);
    final attentionCount = state.attentionDeviceIds.length;
    final subtitle = attentionCount > 0
        ? '$attentionCount device${attentionCount == 1 ? '' : 's'} need attention'
        : (state.devices.isEmpty
            ? 'No devices yet - start by adding your first sensor'
            : '${state.devices.length} device${state.devices.length == 1 ? '' : 's'} monitored');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                initials,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                displayName != null
                    ? '${l10n.dashboardPageHi} $displayName,'
                    : '${l10n.dashboardPageHi},',
                style: Theme.of(context).textTheme.headlineMedium,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: attentionCount > 0
                          ? AppTheme().warning
                          : colorScheme.onSurfaceVariant,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildIconButton(
          context,
          icon: Icons.menu_rounded,
          onTap: () => context.pushNamed(AppRoute.menu.name),
        ),
      ],
    );
  }

  String _initialsFromUser(String? fullName, String? email) {
    final normalized = (fullName ?? '').trim();
    if (normalized.isNotEmpty) {
      final parts = normalized.split(' ').where((p) => p.isNotEmpty).toList();
      if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
      return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
          .toUpperCase();
    }
    final mail = (email ?? '').trim();
    if (mail.isNotEmpty) {
      return mail.substring(0, 1).toUpperCase();
    }
    return '?';
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
