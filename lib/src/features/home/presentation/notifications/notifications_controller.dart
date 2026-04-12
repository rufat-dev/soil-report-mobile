import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/home/domain/notification/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    await Future<void>.delayed(const Duration(milliseconds: 500));
    state = NotificationsState(
      checkState: const AsyncValue.data(null),
      notifications: _mockNotifications,
    );
  }

  Future<void> markAllAsRead() async {
    final updated = state.notifications
        .map((n) => n.copyWith(seen: true))
        .toList();
    state = state.copyWith(
      notifications: updated,
      checkState: const AsyncValue.data(null),
    );
  }

  Future<void> deleteAllMessages() async {
    state = state.copyWith(
      notifications: [],
      checkState: const AsyncValue.data(null),
    );
  }

  Future<void> closeNotification(int id) async {
    final updated = state.notifications
        .map((n) => n.id == id ? n.copyWith(seen: true) : n)
        .toList();
    state = state.copyWith(notifications: updated);
  }

  Future<void> deleteMessage(int id) async {
    final updated =
        state.notifications.where((n) => n.id != id).toList();
    state = state.copyWith(notifications: updated);
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
    id: 1,
    notification: NotificationContent(
      title: 'Welcome',
      body: 'Welcome to the app! Explore the features.',
    ),
    seen: false,
    createdDate: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  NotificationModel(
    id: 2,
    notification: NotificationContent(
      title: 'Update Available',
      body: 'A new version of the app is available.',
    ),
    seen: true,
    createdDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
