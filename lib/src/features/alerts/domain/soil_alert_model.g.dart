// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soil_alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoilAlertModel _$SoilAlertModelFromJson(Map<String, dynamic> json) =>
    SoilAlertModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: $enumDecode(_$SoilAlertSeverityEnumMap, json['severity']),
      siteLabel: json['siteLabel'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$SoilAlertModelToJson(SoilAlertModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'severity': _$SoilAlertSeverityEnumMap[instance.severity]!,
      'siteLabel': instance.siteLabel,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
    };

const _$SoilAlertSeverityEnumMap = {
  SoilAlertSeverity.critical: 'critical',
  SoilAlertSeverity.warning: 'warning',
  SoilAlertSeverity.info: 'info',
};

AlertItemResponse _$AlertItemResponseFromJson(Map<String, dynamic> json) =>
    AlertItemResponse(
      alertId: json['alert_id'] as String?,
      deviceId: json['device_id'] as String?,
      deviceGroupId: json['device_group_id'] as String?,
      userId: json['user_id'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      isRead: json['is_read'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AlertItemResponseToJson(AlertItemResponse instance) =>
    <String, dynamic>{
      'alert_id': instance.alertId,
      'device_id': instance.deviceId,
      'device_group_id': instance.deviceGroupId,
      'user_id': instance.userId,
      'title': instance.title,
      'message': instance.message,
      'is_read': instance.isRead,
      'created_at': instance.createdAt?.toIso8601String(),
    };

AlertUpdateRequest _$AlertUpdateRequestFromJson(Map<String, dynamic> json) =>
    AlertUpdateRequest(
      isRead: json['is_read'] as bool?,
      title: json['title'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$AlertUpdateRequestToJson(AlertUpdateRequest instance) =>
    <String, dynamic>{
      'is_read': instance.isRead,
      'title': instance.title,
      'message': instance.message,
    };
