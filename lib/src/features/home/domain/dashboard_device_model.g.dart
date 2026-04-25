// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardDeviceModel _$DashboardDeviceModelFromJson(
  Map<String, dynamic> json,
) => DashboardDeviceModel(
  deviceId: json['device_id'] as String,
  deviceName: json['device_name'] as String?,
  groupId: json['group_id'] as String?,
  plantType: (json['plant_type'] as num?)?.toInt(),
  soilType: (json['soil_type'] as num?)?.toInt(),
  location: json['location'] as String?,
  locationNotes: json['location_notes'] as String?,
  operationalStatus: (json['operational_status'] as num?)?.toInt(),
  firmwareVersion: json['firmware_version'] as String?,
);

Map<String, dynamic> _$DashboardDeviceModelToJson(
  DashboardDeviceModel instance,
) => <String, dynamic>{
  'device_id': instance.deviceId,
  'device_name': instance.deviceName,
  'group_id': instance.groupId,
  'plant_type': instance.plantType,
  'soil_type': instance.soilType,
  'location': instance.location,
  'location_notes': instance.locationNotes,
  'operational_status': instance.operationalStatus,
  'firmware_version': instance.firmwareVersion,
};

DeviceGroupModel _$DeviceGroupModelFromJson(Map<String, dynamic> json) =>
    DeviceGroupModel(
      groupId: json['group_id'] as String,
      groupName: json['group_name'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$DeviceGroupModelToJson(DeviceGroupModel instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'group_name': instance.groupName,
      'notes': instance.notes,
    };

OperationStatusClassifierModel _$OperationStatusClassifierModelFromJson(
  Map<String, dynamic> json,
) => OperationStatusClassifierModel(
  operationalStatus: (json['operational_status'] as num?)?.toInt(),
  name: json['name'] as String?,
  description: json['description'] as String?,
  instructions: json['instructions'] as String?,
);

Map<String, dynamic> _$OperationStatusClassifierModelToJson(
  OperationStatusClassifierModel instance,
) => <String, dynamic>{
  'operational_status': instance.operationalStatus,
  'name': instance.name,
  'description': instance.description,
  'instructions': instance.instructions,
};

PlantClassifierModel _$PlantClassifierModelFromJson(
  Map<String, dynamic> json,
) => PlantClassifierModel(
  plantType: (json['plant_type'] as num).toInt(),
  plantName: json['plant_name'] as String?,
);

Map<String, dynamic> _$PlantClassifierModelToJson(
  PlantClassifierModel instance,
) => <String, dynamic>{
  'plant_type': instance.plantType,
  'plant_name': instance.plantName,
};

SoilClassifierModel _$SoilClassifierModelFromJson(Map<String, dynamic> json) =>
    SoilClassifierModel(
      soilType: (json['soil_type'] as num).toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$SoilClassifierModelToJson(
  SoilClassifierModel instance,
) => <String, dynamic>{'soil_type': instance.soilType, 'name': instance.name};

DeviceCreatePayload _$DeviceCreatePayloadFromJson(Map<String, dynamic> json) =>
    DeviceCreatePayload(
      deviceId: json['device_id'] as String,
      deviceName: json['device_name'] as String?,
      groupId: json['group_id'] as String?,
      plantType: (json['plant_type'] as num?)?.toInt(),
      soilType: (json['soil_type'] as num?)?.toInt(),
      location: json['location'] as String?,
      locationNotes: json['location_notes'] as String?,
      firmwareVersion: json['firmware_version'] as String?,
    );

Map<String, dynamic> _$DeviceCreatePayloadToJson(
  DeviceCreatePayload instance,
) => <String, dynamic>{
  'device_id': instance.deviceId,
  'device_name': instance.deviceName,
  'group_id': instance.groupId,
  'plant_type': instance.plantType,
  'soil_type': instance.soilType,
  'location': instance.location,
  'location_notes': instance.locationNotes,
  'firmware_version': instance.firmwareVersion,
};

GroupCreatePayload _$GroupCreatePayloadFromJson(Map<String, dynamic> json) =>
    GroupCreatePayload(
      groupName: json['group_name'] as String?,
      notes: json['notes'] as String?,
      location: json['location'] as String?,
      deviceIds: (json['device_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GroupCreatePayloadToJson(GroupCreatePayload instance) =>
    <String, dynamic>{
      'group_name': instance.groupName,
      'notes': instance.notes,
      'location': instance.location,
      if (instance.deviceIds case final value?) 'device_ids': value,
    };
