import 'package:soilreport/src/core/component/custom_bottom_sheet.dart';
import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/features/home/presentation/notifications/notifications_controller.dart';
import 'package:soilreport/src/features/home/domain/notification/notification_model.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(notificationsControllerProvider.notifier)
          .refreshNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(notificationsControllerProvider);
    final activeState = ref
        .read(notificationsControllerProvider.notifier)
        .effectiveState;
    final isLoading = ref
        .read(notificationsControllerProvider.notifier)
        .isEffectiveLoading;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme().gray900Theme(context),
      body: Stack(
        children: [

          Skeletonizer(
            effect: PulseEffect(
              from: AppTheme().gray900Theme(context).withAlpha(240),
              to: AppTheme().gray900Theme(context).withAlpha(10),
              duration: const Duration(milliseconds: 800),
            ),
            ignorePointers: isLoading,
            enabled: isLoading,
            child: SizedBox(
              width: 100.sw(context),
              child: RefreshIndicator(
                color: Theme.of(context).colorScheme.primary,
                onRefresh: () => ref
                    .read(notificationsControllerProvider.notifier)
                    .refreshNotifications(),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(height: 100.devicePaddingTop(context)),
                  ),
                  SliverToBoxAdapter(
                    child: Skeleton.keep(
                      child: _buildHeader(context, l10n),
                    ),
                  ),
                  if (activeState.notifications.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _buildNotificationsList(
                          context, ref, activeState.notifications, l10n),
                    )
                  else
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(context, l10n),
                    ),
                ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showActionsBottomSheet(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final controller =
        ref.read(notificationsControllerProvider.notifier);
    await showCustomModalBottomSheet(
      initialChildSize: 0.2,
      minChildSize: 0.15,
      maxChildSize: 0.4,
      context: context,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      await controller.markAllAsRead();
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme().surfaceDark700,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            width: 20,
                            height: 20,
                            color: Colors.white,
                            'assets/images/static/check.png',
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l10n.notificationMarkAllAsRead,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      await controller.deleteAllMessages();
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme().surfaceDark700,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            width: 20,
                            height: 20,
                            color: Colors.red,
                            'assets/images/static/trash-2.png',
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l10n.notificationDeleteAllMessage,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Image.asset(
              'assets/images/static/arrow-left.png',
              color: onSurface,
              height: 24,
              width: 24,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                l10n.notificationPageHeader,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: onSurface),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showActionsBottomSheet(context, l10n),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: List.generate(
                  3,
                  (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: onSurface,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    WidgetRef ref,
    List<NotificationModel> notifications,
    AppLocalizations l10n,
  ) {
    final unreadCount =
        notifications.where((e) => e.seen == false).length;
    return Container(
      width: 100.sw(context),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppTheme().gray800Theme(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notificationUnreadCount(unreadCount),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 15),
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: notifications.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildNotificationItem(
                    context, ref, notifications[index], l10n);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notification,
    AppLocalizations l10n,
  ) {
    final isRead = notification.seen ?? false;
    final controller =
        ref.read(notificationsControllerProvider.notifier);

    return Dismissible(
      key: Key('notification_${notification.id ?? 'unknown'}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          l10n.notificationSwipeDelete,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      onDismissed: (_) => controller.deleteMessage(notification.id),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: GestureDetector(
          onTap: () =>
              _showNotificationDetail(context, notification, l10n),
          child: Container(
            width: double.maxFinite,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: context.isDarkMode
                  ? AppTheme().surfaceDark700
                  : isRead
                      ? AppTheme().gray100
                      : AppTheme().white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    height: 33,
                    width: 33,
                    child: Stack(
                      children: [
                        Image.asset(
                          width: 30,
                          'assets/images/static/bell.png',
                        ),
                        if (!isRead)
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme().orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.notification?.title ?? '',
                        style: Theme.of(context).textTheme.displaySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        notification.notification?.body ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    _formatDate(notification.createdDate),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showNotificationDetail(
    BuildContext context,
    NotificationModel notification,
    AppLocalizations l10n,
  ) async {
    final controller =
        ref.read(notificationsControllerProvider.notifier);
    await showCustomModalBottomSheet(
      context: context,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Image.asset(
                    width: 49,
                    height: 49,
                    'assets/images/static/bell.png',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 17),
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.notification?.title ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _formatDate(notification.createdDate),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme().surfaceDark700,
            ),
            padding: const EdgeInsets.all(20),
            child: Text(
              notification.notification?.body ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme().orange,
                ),
                child: Center(
                  child: Text(
                    l10n.notificationDetailClose,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    await controller.closeNotification(notification.id);
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: 100.sw(context),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppTheme().gray800Theme(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notificationUnreadCount(0),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      width: 90,
                      'assets/images/static/inbox.png',
                    ),
                    Text(
                      l10n.notificationThereIsNoNotification,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) return '${difference.inDays} days ago';
    if (difference.inHours > 0) return '${difference.inHours} hours ago';
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    }
    return 'Just now';
  }
}
