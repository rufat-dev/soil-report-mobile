import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_device_model.g.dart';

enum PlatformType {
  @JsonValue(1)
  android,
  
  @JsonValue(2)
  ios,
}

@JsonSerializable()
class NotificationDeviceModel extends Equatable {
  final String? token;
  final PlatformType platform;
  final String? deviceId;
  final String? userId;

  const NotificationDeviceModel({
    this.token,
    required this.platform,
    this.deviceId,
    this.userId,
  });

  factory NotificationDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationDeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDeviceModelToJson(this);

  @override
  List<Object?> get props => [token, platform, deviceId, userId];
}

