class PurchaseRecordModel {
  final String purchaseId;
  final String userId;
  final String deviceId;
  final String? purchaseDate;
  final int? status;
  final String? price;
  final String? currency;
  final String? notes;

  const PurchaseRecordModel({
    required this.purchaseId,
    required this.userId,
    required this.deviceId,
    this.purchaseDate,
    this.status,
    this.price,
    this.currency,
    this.notes,
  });

  DateTime? get purchaseDateTime =>
      purchaseDate == null ? null : DateTime.tryParse(purchaseDate!);

  factory PurchaseRecordModel.fromJson(Map<String, dynamic> json) {
    return PurchaseRecordModel(
      purchaseId: (json['purchase_id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      deviceId: (json['device_id'] ?? '').toString(),
      purchaseDate: json['purchase_date']?.toString(),
      status: json['status'] is int ? json['status'] as int : null,
      price: json['price']?.toString(),
      currency: json['currency']?.toString(),
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchase_id': purchaseId,
      'user_id': userId,
      'device_id': deviceId,
      'purchase_date': purchaseDate,
      'status': status,
      'price': price,
      'currency': currency,
      'notes': notes,
    };
  }
}
