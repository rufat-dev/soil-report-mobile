import 'package:json_annotation/json_annotation.dart';

part 'soil_recommendation_model.g.dart';

@JsonSerializable()
class SoilRecommendationModel {
  final int id;
  final String title;
  final String description;
  final RecommendationCategory category;
  final RecommendationPriority priority;
  final String siteLabel;
  final DateTime createdAt;
  final bool isApplied;

  const SoilRecommendationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.siteLabel,
    required this.createdAt,
    this.isApplied = false,
  });

  factory SoilRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$SoilRecommendationModelFromJson(json);

  Map<String, dynamic> toJson() => _$SoilRecommendationModelToJson(this);

  SoilRecommendationModel copyWith({
    int? id,
    String? title,
    String? description,
    RecommendationCategory? category,
    RecommendationPriority? priority,
    String? siteLabel,
    DateTime? createdAt,
    bool? isApplied,
  }) {
    return SoilRecommendationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      siteLabel: siteLabel ?? this.siteLabel,
      createdAt: createdAt ?? this.createdAt,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}

enum RecommendationCategory {
  fertilization,
  irrigation,
  soilAmendment,
  pestControl,
  general,
}

enum RecommendationPriority { high, medium, low }

@JsonSerializable()
class AiRecommendationResponse {
  final List<AiRecommendationItem> items;

  const AiRecommendationResponse({required this.items});

  factory AiRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$AiRecommendationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AiRecommendationResponseToJson(this);
}

@JsonSerializable()
class AiRecommendationItem {
  @JsonKey(name: 'recommendation_id')
  final String? recommendationId;
  @JsonKey(name: 'device_id')
  final String? deviceId;
  final String? title;
  final String? summary;
  final String? recommendation;
  final String? priority;
  @JsonKey(name: 'reasoning_scope')
  final String? reasoningScope;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'insight_date')
  final DateTime? insightDate;

  const AiRecommendationItem({
    this.recommendationId,
    this.deviceId,
    this.title,
    this.summary,
    this.recommendation,
    this.priority,
    this.reasoningScope,
    this.createdAt,
    this.insightDate,
  });

  factory AiRecommendationItem.fromJson(Map<String, dynamic> json) =>
      _$AiRecommendationItemFromJson(json);

  Map<String, dynamic> toJson() => _$AiRecommendationItemToJson(this);
}

class AiForecastItem {
  final String? forecastId;
  final String? deviceId;
  final String? metric;
  final DateTime? forecastFor;
  final double? predictedValue;
  final String? unit;
  final String? confidence;

  const AiForecastItem({
    this.forecastId,
    this.deviceId,
    this.metric,
    this.forecastFor,
    this.predictedValue,
    this.unit,
    this.confidence,
  });

  factory AiForecastItem.fromJson(Map<String, dynamic> json) {
    double? pickPredictedValue() {
      final orderedCandidates = <dynamic>[
        json['predicted_temperature'],
        json['predicted_moisture'],
        json['predicted_conductivity'],
        json['predicted_ph_value'],
        json['predicted_risk_score'],
        json['predicted_value'],
      ];
      for (final candidate in orderedCandidates) {
        if (candidate is num) return candidate.toDouble();
        if (candidate is String) {
          final parsed = double.tryParse(candidate);
          if (parsed != null) return parsed;
        }
      }
      return null;
    }

    ({String? metric, String? unit}) pickMetricAndUnit() {
      final mapped = <({String key, String metric, String unit})>[
        (key: 'predicted_temperature', metric: 'Temperature', unit: '°C'),
        (key: 'predicted_moisture', metric: 'Moisture', unit: '%'),
        (key: 'predicted_conductivity', metric: 'Conductivity', unit: 'µS/cm'),
        (key: 'predicted_ph_value', metric: 'pH', unit: ''),
        (key: 'predicted_risk_score', metric: 'Risk score', unit: ''),
      ];

      for (final item in mapped) {
        if (json[item.key] != null) {
          return (metric: item.metric, unit: item.unit);
        }
      }

      return (
        metric: json['title']?.toString() ?? json['metric']?.toString(),
        unit: json['unit']?.toString(),
      );
    }

    final metricAndUnit = pickMetricAndUnit();
    final confidenceValue = json['confidence'];

    return AiForecastItem(
      forecastId: json['forecast_id']?.toString(),
      deviceId: json['device_id']?.toString(),
      metric: metricAndUnit.metric,
      forecastFor: DateTime.tryParse(
        (json['forecast_for_time'] ?? json['forecast_for'] ?? '').toString(),
      ),
      predictedValue: pickPredictedValue(),
      unit: metricAndUnit.unit,
      confidence: confidenceValue is num
          ? confidenceValue.toStringAsFixed(2)
          : confidenceValue?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'forecast_id': forecastId,
    'device_id': deviceId,
    'metric': metric,
    'forecast_for': forecastFor?.toIso8601String(),
    'predicted_value': predictedValue,
    'unit': unit,
    'confidence': confidence,
  };
}
