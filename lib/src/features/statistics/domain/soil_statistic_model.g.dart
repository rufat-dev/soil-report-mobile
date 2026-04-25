// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soil_statistic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoilStatisticModel _$SoilStatisticModelFromJson(Map<String, dynamic> json) =>
    SoilStatisticModel(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      trend:
          $enumDecodeNullable(_$SoilStatisticTrendEnumMap, json['trend']) ??
          SoilStatisticTrend.stable,
    );

Map<String, dynamic> _$SoilStatisticModelToJson(SoilStatisticModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'unit': instance.unit,
      'trend': _$SoilStatisticTrendEnumMap[instance.trend]!,
    };

const _$SoilStatisticTrendEnumMap = {
  SoilStatisticTrend.up: 'up',
  SoilStatisticTrend.down: 'down',
  SoilStatisticTrend.stable: 'stable',
};

SoilSampleModel _$SoilSampleModelFromJson(Map<String, dynamic> json) =>
    SoilSampleModel(
      id: (json['id'] as num).toInt(),
      siteLabel: json['siteLabel'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      collectedAt: DateTime.parse(json['collectedAt'] as String),
      phLevel: (json['phLevel'] as num).toDouble(),
      moisturePercent: (json['moisturePercent'] as num).toDouble(),
      nitrogenPpm: (json['nitrogenPpm'] as num).toDouble(),
      phosphorusPpm: (json['phosphorusPpm'] as num).toDouble(),
      potassiumPpm: (json['potassiumPpm'] as num).toDouble(),
      organicMatterPercent: (json['organicMatterPercent'] as num).toDouble(),
    );

Map<String, dynamic> _$SoilSampleModelToJson(SoilSampleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'siteLabel': instance.siteLabel,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'collectedAt': instance.collectedAt.toIso8601String(),
      'phLevel': instance.phLevel,
      'moisturePercent': instance.moisturePercent,
      'nitrogenPpm': instance.nitrogenPpm,
      'phosphorusPpm': instance.phosphorusPpm,
      'potassiumPpm': instance.potassiumPpm,
      'organicMatterPercent': instance.organicMatterPercent,
    };

DeviceListResponse _$DeviceListResponseFromJson(Map<String, dynamic> json) =>
    DeviceListResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => DeviceResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeviceListResponseToJson(DeviceListResponse instance) =>
    <String, dynamic>{'items': instance.items};

DeviceResponse _$DeviceResponseFromJson(Map<String, dynamic> json) =>
    DeviceResponse(deviceId: json['device_id'] as String?);

Map<String, dynamic> _$DeviceResponseToJson(DeviceResponse instance) =>
    <String, dynamic>{'device_id': instance.deviceId};

DeviceStateLatestResponse _$DeviceStateLatestResponseFromJson(
  Map<String, dynamic> json,
) => DeviceStateLatestResponse(
  phValue: (json['ph_value'] as num?)?.toDouble(),
  moisture: (json['moisture'] as num?)?.toDouble(),
  conductivity: (json['conductivity'] as num?)?.toDouble(),
  npkN: (json['npk_n'] as num?)?.toDouble(),
  npkP: (json['npk_p'] as num?)?.toDouble(),
  npkK: (json['npk_k'] as num?)?.toDouble(),
  moistureTrend: json['moisture_trend'] as String?,
  conductivityTrend: json['conductivity_trend'] as String?,
);

Map<String, dynamic> _$DeviceStateLatestResponseToJson(
  DeviceStateLatestResponse instance,
) => <String, dynamic>{
  'ph_value': instance.phValue,
  'moisture': instance.moisture,
  'conductivity': instance.conductivity,
  'npk_n': instance.npkN,
  'npk_p': instance.npkP,
  'npk_k': instance.npkK,
  'moisture_trend': instance.moistureTrend,
  'conductivity_trend': instance.conductivityTrend,
};

DeviceTimeseriesHourlyResponse _$DeviceTimeseriesHourlyResponseFromJson(
  Map<String, dynamic> json,
) => DeviceTimeseriesHourlyResponse(
  points: (json['points'] as List<dynamic>)
      .map(
        (e) =>
            DeviceTimeseriesPointResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$DeviceTimeseriesHourlyResponseToJson(
  DeviceTimeseriesHourlyResponse instance,
) => <String, dynamic>{'points': instance.points};

DeviceTimeseriesPointResponse _$DeviceTimeseriesPointResponseFromJson(
  Map<String, dynamic> json,
) => DeviceTimeseriesPointResponse(
  hourTs: json['hour_ts'] == null
      ? null
      : DateTime.parse(json['hour_ts'] as String),
  avgPhValue: (json['avg_ph_value'] as num?)?.toDouble(),
  avgMoisture: (json['avg_moisture'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DeviceTimeseriesPointResponseToJson(
  DeviceTimeseriesPointResponse instance,
) => <String, dynamic>{
  'hour_ts': instance.hourTs?.toIso8601String(),
  'avg_ph_value': instance.avgPhValue,
  'avg_moisture': instance.avgMoisture,
};
