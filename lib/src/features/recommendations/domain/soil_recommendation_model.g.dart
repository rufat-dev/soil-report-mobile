// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soil_recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoilRecommendationModel _$SoilRecommendationModelFromJson(
  Map<String, dynamic> json,
) => SoilRecommendationModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  category: $enumDecode(_$RecommendationCategoryEnumMap, json['category']),
  priority: $enumDecode(_$RecommendationPriorityEnumMap, json['priority']),
  siteLabel: json['siteLabel'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isApplied: json['isApplied'] as bool? ?? false,
);

Map<String, dynamic> _$SoilRecommendationModelToJson(
  SoilRecommendationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': _$RecommendationCategoryEnumMap[instance.category]!,
  'priority': _$RecommendationPriorityEnumMap[instance.priority]!,
  'siteLabel': instance.siteLabel,
  'createdAt': instance.createdAt.toIso8601String(),
  'isApplied': instance.isApplied,
};

const _$RecommendationCategoryEnumMap = {
  RecommendationCategory.fertilization: 'fertilization',
  RecommendationCategory.irrigation: 'irrigation',
  RecommendationCategory.soilAmendment: 'soilAmendment',
  RecommendationCategory.pestControl: 'pestControl',
  RecommendationCategory.general: 'general',
};

const _$RecommendationPriorityEnumMap = {
  RecommendationPriority.high: 'high',
  RecommendationPriority.medium: 'medium',
  RecommendationPriority.low: 'low',
};

AiRecommendationResponse _$AiRecommendationResponseFromJson(
  Map<String, dynamic> json,
) => AiRecommendationResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => AiRecommendationItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AiRecommendationResponseToJson(
  AiRecommendationResponse instance,
) => <String, dynamic>{'items': instance.items};

AiRecommendationItem _$AiRecommendationItemFromJson(
  Map<String, dynamic> json,
) => AiRecommendationItem(
  recommendationId: json['recommendation_id'] as String?,
  deviceId: json['device_id'] as String?,
  title: json['title'] as String?,
  summary: json['summary'] as String?,
  recommendation: json['recommendation'] as String?,
  priority: json['priority'] as String?,
  reasoningScope: json['reasoning_scope'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  insightDate: json['insight_date'] == null
      ? null
      : DateTime.parse(json['insight_date'] as String),
);

Map<String, dynamic> _$AiRecommendationItemToJson(
  AiRecommendationItem instance,
) => <String, dynamic>{
  'recommendation_id': instance.recommendationId,
  'device_id': instance.deviceId,
  'title': instance.title,
  'summary': instance.summary,
  'recommendation': instance.recommendation,
  'priority': instance.priority,
  'reasoning_scope': instance.reasoningScope,
  'created_at': instance.createdAt?.toIso8601String(),
  'insight_date': instance.insightDate?.toIso8601String(),
};
