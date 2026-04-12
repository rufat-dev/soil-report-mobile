// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDeviceModel _$NotificationDeviceModelFromJson(
  Map<String, dynamic> json,
) => NotificationDeviceModel(
  token: json['token'] as String?,
  platform: $enumDecode(_$PlatformTypeEnumMap, json['platform']),
  deviceId: json['deviceId'] as String?,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$NotificationDeviceModelToJson(
  NotificationDeviceModel instance,
) => <String, dynamic>{
  'token': instance.token,
  'platform': _$PlatformTypeEnumMap[instance.platform]!,
  'deviceId': instance.deviceId,
  'userId': instance.userId,
};

const _$PlatformTypeEnumMap = {PlatformType.android: 1, PlatformType.ios: 2};
