class NotificationModel {
  final int? id;
  final NotificationContent? notification;
  final bool? seen;
  final DateTime? createdDate;

  const NotificationModel({
    this.id,
    this.notification,
    this.seen,
    this.createdDate,
  });

  NotificationModel copyWith({
    int? id,
    NotificationContent? notification,
    bool? seen,
    DateTime? createdDate,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      notification: notification ?? this.notification,
      seen: seen ?? this.seen,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}

class NotificationContent {
  final String? title;
  final String? body;

  const NotificationContent({this.title, this.body});
}
