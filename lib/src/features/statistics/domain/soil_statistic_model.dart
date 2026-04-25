import 'package:json_annotation/json_annotation.dart';

part 'soil_statistic_model.g.dart';

@JsonSerializable()
class SoilStatisticModel {
  final String label;
  final double value;
  final String unit;
  final SoilStatisticTrend trend;

  const SoilStatisticModel({
    required this.label,
    required this.value,
    required this.unit,
    this.trend = SoilStatisticTrend.stable,
  });

  factory SoilStatisticModel.fromJson(Map<String, dynamic> json) =>
      _$SoilStatisticModelFromJson(json);

  Map<String, dynamic> toJson() => _$SoilStatisticModelToJson(this);
}

enum SoilStatisticTrend { up, down, stable }

@JsonSerializable()
class SoilSampleModel {
  final int id;
  final String siteLabel;
  final double latitude;
  final double longitude;
  final DateTime collectedAt;
  final double phLevel;
  final double moisturePercent;
  final double nitrogenPpm;
  final double phosphorusPpm;
  final double potassiumPpm;
  final double organicMatterPercent;

  const SoilSampleModel({
    required this.id,
    required this.siteLabel,
    required this.latitude,
    required this.longitude,
    required this.collectedAt,
    required this.phLevel,
    required this.moisturePercent,
    required this.nitrogenPpm,
    required this.phosphorusPpm,
    required this.potassiumPpm,
    required this.organicMatterPercent,
  });

  factory SoilSampleModel.fromJson(Map<String, dynamic> json) =>
      _$SoilSampleModelFromJson(json);

  Map<String, dynamic> toJson() => _$SoilSampleModelToJson(this);
}

@JsonSerializable()
class DeviceListResponse {
  final List<DeviceResponse> items;

  const DeviceListResponse({required this.items});

  factory DeviceListResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceListResponseToJson(this);
}

@JsonSerializable()
class DeviceResponse {
  @JsonKey(name: 'device_id')
  final String? deviceId;

  const DeviceResponse({this.deviceId});

  factory DeviceResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceResponseToJson(this);
}

@JsonSerializable()
class DeviceStateLatestResponse {
  @JsonKey(name: 'ph_value')
  final double? phValue;
  final double? moisture;
  final double? conductivity;
  @JsonKey(name: 'npk_n')
  final double? npkN;
  @JsonKey(name: 'npk_p')
  final double? npkP;
  @JsonKey(name: 'npk_k')
  final double? npkK;
  @JsonKey(name: 'moisture_trend')
  final String? moistureTrend;
  @JsonKey(name: 'conductivity_trend')
  final String? conductivityTrend;

  const DeviceStateLatestResponse({
    this.phValue,
    this.moisture,
    this.conductivity,
    this.npkN,
    this.npkP,
    this.npkK,
    this.moistureTrend,
    this.conductivityTrend,
  });

  factory DeviceStateLatestResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceStateLatestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceStateLatestResponseToJson(this);
}

@JsonSerializable()
class DeviceTimeseriesHourlyResponse {
  final List<DeviceTimeseriesPointResponse> points;

  const DeviceTimeseriesHourlyResponse({required this.points});

  factory DeviceTimeseriesHourlyResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceTimeseriesHourlyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceTimeseriesHourlyResponseToJson(this);
}

@JsonSerializable()
class DeviceTimeseriesPointResponse {
  @JsonKey(name: 'hour_ts')
  final DateTime? hourTs;
  @JsonKey(name: 'avg_ph_value')
  final double? avgPhValue;
  @JsonKey(name: 'avg_moisture')
  final double? avgMoisture;

  const DeviceTimeseriesPointResponse({
    this.hourTs,
    this.avgPhValue,
    this.avgMoisture,
  });

  factory DeviceTimeseriesPointResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceTimeseriesPointResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceTimeseriesPointResponseToJson(this);
}
