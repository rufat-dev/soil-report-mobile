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
