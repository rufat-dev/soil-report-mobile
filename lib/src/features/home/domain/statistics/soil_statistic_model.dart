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
}

enum SoilStatisticTrend { up, down, stable }

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
}
