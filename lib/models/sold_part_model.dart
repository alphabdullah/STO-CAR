/// Sold Part model representing a part that has been sold
class SoldPartModel {
  final String id;
  final String partId;
  final String partName;
  final String companyId;
  final String companyName;
  final String category;
  final double price;
  final String currency;
  final int quantity;
  final double totalAmount;
  final DateTime soldAt;
  final String? buyerName;
  final String? buyerId;

  const SoldPartModel({
    required this.id,
    required this.partId,
    required this.partName,
    required this.companyId,
    required this.companyName,
    required this.category,
    required this.price,
    this.currency = 'AED',
    required this.quantity,
    required this.totalAmount,
    required this.soldAt,
    this.buyerName,
    this.buyerId,
  });

  SoldPartModel copyWith({
    String? id,
    String? partId,
    String? partName,
    String? companyId,
    String? companyName,
    String? category,
    double? price,
    String? currency,
    int? quantity,
    double? totalAmount,
    DateTime? soldAt,
    String? buyerName,
    String? buyerId,
  }) {
    return SoldPartModel(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      partName: partName ?? this.partName,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      category: category ?? this.category,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
      soldAt: soldAt ?? this.soldAt,
      buyerName: buyerName ?? this.buyerName,
      buyerId: buyerId ?? this.buyerId,
    );
  }
}

