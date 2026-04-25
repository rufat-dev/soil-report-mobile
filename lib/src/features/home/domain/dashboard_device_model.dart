import 'package:json_annotation/json_annotation.dart';

part 'dashboard_device_model.g.dart';

@JsonSerializable()
class DashboardDeviceModel {
  @JsonKey(name: 'device_id')
  final String deviceId;
  @JsonKey(name: 'device_name')
  final String? deviceName;
  @JsonKey(name: 'group_id')
  final String? groupId;
  @JsonKey(name: 'plant_type')
  final int? plantType;
  @JsonKey(name: 'soil_type')
  final int? soilType;
  final String? location;
  @JsonKey(name: 'location_notes')
  final String? locationNotes;
  @JsonKey(name: 'operational_status')
  final int? operationalStatus;
  @JsonKey(name: 'firmware_version')
  final String? firmwareVersion;

  const DashboardDeviceModel({
    required this.deviceId,
    this.deviceName,
    this.groupId,
    this.plantType,
    this.soilType,
    this.location,
    this.locationNotes,
    this.operationalStatus,
    this.firmwareVersion,
  });

  factory DashboardDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardDeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardDeviceModelToJson(this);
}

@JsonSerializable()
class DeviceGroupModel {
  @JsonKey(name: 'group_id')
  final String groupId;
  @JsonKey(name: 'group_name')
  final String? groupName;
  final String? notes;

  const DeviceGroupModel({required this.groupId, this.groupName, this.notes});

  factory DeviceGroupModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceGroupModelToJson(this);
}

@JsonSerializable()
class OperationStatusClassifierModel {
  @JsonKey(name: 'operational_status')
  final int? operationalStatus;
  final String? name;
  final String? description;
  final String? instructions;

  const OperationStatusClassifierModel({
    this.operationalStatus,
    this.name,
    this.description,
    this.instructions,
  });

  factory OperationStatusClassifierModel.fromJson(Map<String, dynamic> json) =>
      _$OperationStatusClassifierModelFromJson(json);

  Map<String, dynamic> toJson() => _$OperationStatusClassifierModelToJson(this);
}

@JsonSerializable()
class PlantClassifierModel {
  @JsonKey(name: 'plant_type')
  final int plantType;
  @JsonKey(name: 'plant_name')
  final String? plantName;

  const PlantClassifierModel({required this.plantType, this.plantName});

  factory PlantClassifierModel.fromJson(Map<String, dynamic> json) =>
      _$PlantClassifierModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlantClassifierModelToJson(this);
}

@JsonSerializable()
class SoilClassifierModel {
  @JsonKey(name: 'soil_type')
  final int soilType;
  final String? name;

  const SoilClassifierModel({required this.soilType, this.name});

  factory SoilClassifierModel.fromJson(Map<String, dynamic> json) =>
      _$SoilClassifierModelFromJson(json);

  Map<String, dynamic> toJson() => _$SoilClassifierModelToJson(this);
}

@JsonSerializable()
class DeviceCreatePayload {
  @JsonKey(name: 'device_id')
  final String deviceId;
  @JsonKey(name: 'device_name')
  final String? deviceName;
  @JsonKey(name: 'group_id')
  final String? groupId;
  @JsonKey(name: 'plant_type')
  final int? plantType;
  @JsonKey(name: 'soil_type')
  final int? soilType;
  final String? location;
  @JsonKey(name: 'location_notes')
  final String? locationNotes;
  @JsonKey(name: 'firmware_version')
  final String? firmwareVersion;

  const DeviceCreatePayload({
    required this.deviceId,
    this.deviceName,
    this.groupId,
    this.plantType,
    this.soilType,
    this.location,
    this.locationNotes,
    this.firmwareVersion,
  });

  factory DeviceCreatePayload.fromJson(Map<String, dynamic> json) =>
      _$DeviceCreatePayloadFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceCreatePayloadToJson(this);
}

@JsonSerializable()
class GroupCreatePayload {
  @JsonKey(name: 'group_name')
  final String? groupName;
  final String? notes;
  final String? location;
  @JsonKey(name: 'device_ids', includeIfNull: false)
  final List<String>? deviceIds;

  const GroupCreatePayload({
    this.groupName,
    this.notes,
    this.location,
    this.deviceIds,
  });

  factory GroupCreatePayload.fromJson(Map<String, dynamic> json) =>
      _$GroupCreatePayloadFromJson(json);

  Map<String, dynamic> toJson() => _$GroupCreatePayloadToJson(this);
}
