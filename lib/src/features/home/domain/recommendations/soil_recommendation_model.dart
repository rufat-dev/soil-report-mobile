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

enum RecommendationCategory { fertilization, irrigation, soilAmendment, pestControl, general }

enum RecommendationPriority { high, medium, low }
