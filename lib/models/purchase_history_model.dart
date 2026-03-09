/// Model for user's part purchase history (from my-purchases API)
class PurchaseHistoryModel {
  final String id;
  final String partId;
  final String partName;
  final String? partImageUrl;
  final String sellerName;
  final double soldPrice;
  final int quantity;
  final double totalAmount;
  final String status;
  final String? trackingNumber;
  final DateTime purchasedAt;

  const PurchaseHistoryModel({
    required this.id,
    required this.partId,
    required this.partName,
    this.partImageUrl,
    required this.sellerName,
    required this.soldPrice,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    this.trackingNumber,
    required this.purchasedAt,
  });

  factory PurchaseHistoryModel.fromJson(Map<String, dynamic> json) {
    final part = json['part'] as Map<String, dynamic>? ?? {};
    final seller = json['seller'] as Map<String, dynamic>? ?? {};
    final img = part['image'];
    return PurchaseHistoryModel(
      id: (json['id'] ?? '').toString(),
      partId: (part['id'] ?? '').toString(),
      partName: (part['name'] ?? '').toString(),
      partImageUrl: img != null ? img.toString() : null,
      sellerName: (seller['name'] ?? '').toString(),
      soldPrice: (json['sold_price'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      status: (json['status'] ?? 'paid').toString(),
      trackingNumber: json['tracking_number']?.toString(),
      purchasedAt: json['purchased_at'] != null
          ? DateTime.tryParse(json['purchased_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
