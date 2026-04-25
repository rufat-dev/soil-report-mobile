import 'package:json_annotation/json_annotation.dart';

part 'soil_alert_model.g.dart';

@JsonSerializable()
class SoilAlertModel {
  /// CRM `alert_id` from GET `/alerts`.
  final String id;
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

  factory SoilAlertModel.fromJson(Map<String, dynamic> json) =>
      _$SoilAlertModelFromJson(json);

  Map<String, dynamic> toJson() => _$SoilAlertModelToJson(this);

  SoilAlertModel copyWith({
    String? id,
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

@JsonSerializable()
class AlertItemResponse {
  @JsonKey(name: 'alert_id')
  final String? alertId;
  @JsonKey(name: 'device_id')
  final String? deviceId;
  @JsonKey(name: 'device_group_id')
  final String? deviceGroupId;
  @JsonKey(name: 'user_id')
  final String? userId;
  final String? title;
  final String? message;
  @JsonKey(name: 'is_read')
  final bool? isRead;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const AlertItemResponse({
    this.alertId,
    this.deviceId,
    this.deviceGroupId,
    this.userId,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
  });

  factory AlertItemResponse.fromJson(Map<String, dynamic> json) =>
      _$AlertItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AlertItemResponseToJson(this);
}

@JsonSerializable()
class AlertUpdateRequest {
  @JsonKey(name: 'is_read')
  final bool? isRead;
  final String? title;
  final String? message;

  const AlertUpdateRequest({this.isRead, this.title, this.message});

  factory AlertUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$AlertUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AlertUpdateRequestToJson(this);
}
