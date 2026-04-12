class SoilAlertModel {
  final int id;
  final String title;
  final String description;
  final SoilAlertSeverity severity;
  final String siteLabel;
  final DateTime createdAt;
  final bool isRead;

  const SoilAlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.siteLabel,
    required this.createdAt,
    this.isRead = false,
  });

  SoilAlertModel copyWith({
    int? id,
    String? title,
    String? description,
    SoilAlertSeverity? severity,
    String? siteLabel,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return SoilAlertModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      siteLabel: siteLabel ?? this.siteLabel,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum SoilAlertSeverity { critical, warning, info }
