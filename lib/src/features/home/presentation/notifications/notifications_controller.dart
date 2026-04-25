import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/alerts/data/alerts_repository.dart';
import 'package:soilreport/src/features/alerts/domain/soil_alert_model.dart';
import 'package:soilreport/src/features/home/domain/notification/notification_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_controller.g.dart';

@riverpod
class NotificationsController extends _$NotificationsController
    with MockableControllerMixin<NotificationsState> {
  @override
  NotificationsState build() {
    return const NotificationsState(
      checkState: null,
      notifications: [],
    );
  }

  @override
  NotificationsState get mockState => NotificationsState(
        checkState: const AsyncValue.data(null),
        notifications: _mockNotifications,
      );

  @override
  NotificationsState get mockLoadingState => const NotificationsState(
        checkState: AsyncValue.loading(),
        notifications: [],
      );

  Future<void> refreshNotifications() async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    try {
      final repo = ref.read(alertsRepositoryProvider);
      final rows = await repo.listAlerts(limit: 100, useCache: false);
      final list = <NotificationModel>[];
      for (final row in rows) {
        final aid = row.alertId?.trim();
        if (aid == null || aid.isEmpty) {
          continue;
        }
        final body = row.message ?? '';
        final title = (row.title != null && row.title!.trim().isNotEmpty)
            ? row.title!.trim()
            : _titleFromBody(body);
        list.add(
          NotificationModel(
            id: aid,
            notification: NotificationContent(title: title, body: body),
            seen: row.isRead == true,
            createdDate: row.createdAt,
          ),
        );
      }
      state = NotificationsState(
        checkState: const AsyncValue.data(null),
        notifications: list,
      );
    } catch (_) {
      state = NotificationsState(
        checkState: const AsyncValue.data(null),
        notifications: const [],
      );
    }
  }

  Future<void> markAllAsRead() async {
    final repo = ref.read(alertsRepositoryProvider);
    final unread = state.notifications.where((n) => n.seen != true).toList();
    for (final n in unread) {
      final id = n.id;
      if (id == null || id.isEmpty) {
        continue;
      }
      try {
        await repo.updateAlert(id, const AlertUpdateRequest(isRead: true));
      } catch (_) {
        /* ignore */
      }
    }
    final updated =
        state.notifications.map((n) => n.copyWith(seen: true)).toList();
    state = state.copyWith(
      notifications: updated,
      checkState: const AsyncValue.data(null),
    );
  }

  Future<void> deleteAllMessages() async {
    final repo = ref.read(alertsRepositoryProvider);
    for (final n in state.notifications) {
        final id = n.id;
        if (id == null || id.isEmpty) {
          continue;
        }
        try {
          await repo.deleteAlert(id);
        } catch (_) {
          /* ignore */
        }
    }
    state = state.copyWith(
      notifications: [],
      checkState: const AsyncValue.data(null),
    );
  }

  Future<void> closeNotification(String? alertId) async {
    if (alertId == null || alertId.isEmpty) {
      return;
    }
    final repo = ref.read(alertsRepositoryProvider);
    try {
      await repo.updateAlert(alertId, const AlertUpdateRequest(isRead: true));
    } catch (_) {
      /* ignore */
    }
    final updated = state.notifications
        .map((n) => n.id == alertId ? n.copyWith(seen: true) : n)
        .toList();
    state = state.copyWith(notifications: updated);
  }

  Future<void> deleteMessage(String? alertId) async {
    if (alertId == null || alertId.isEmpty) {
      return;
    }
    final repo = ref.read(alertsRepositoryProvider);
    try {
      await repo.deleteAlert(alertId);
    } catch (_) {
      /* ignore */
    }
    final updated = state.notifications.where((n) => n.id != alertId).toList();
    state = state.copyWith(notifications: updated);
  }

  static String _titleFromBody(String body) {
    if (body.isEmpty) {
      return 'Notification';
    }
    final line = body.split('\n').first.trim();
    if (line.length <= 64) {
      return line;
    }
    return '${line.substring(0, 61)}…';
  }
}

class NotificationsState extends BaseState {
  final List<NotificationModel> notifications;

  const NotificationsState({
    super.checkState,
    required this.notifications,
  });

  NotificationsState copyWith({
    AsyncValue<String?>? checkState,
    List<NotificationModel>? notifications,
  }) {
    return NotificationsState(
      checkState: checkState ?? this.checkState,
      notifications: notifications ?? this.notifications,
    );
  }
}

final _mockNotifications = [
  NotificationModel(
    id: 'mock-welcome',
    notification: const NotificationContent(
      title: 'Welcome',
      body: 'Welcome to the app! Explore the features.',
    ),
    seen: false,
    createdDate: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  NotificationModel(
    id: 'mock-update',
    notification: const NotificationContent(
      title: 'Update Available',
      body: 'A new version of the app is available.',
    ),
    seen: true,
    createdDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
