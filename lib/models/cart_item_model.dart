/// Cart item model - matches backend cart API response
class CartItemModel {
  final String id;
  final String partId;
  final String name;
  final String? imageUrl;
  final double price;
  final int quantity;
  final double subtotal;
  final String currency;

  const CartItemModel({
    required this.id,
    required this.partId,
    required this.name,
    this.imageUrl,
    required this.price,
    required this.quantity,
    required this.subtotal,
    this.currency = 'AED',
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id']?.toString() ?? '',
      partId: map['part_id']?.toString() ?? map['part']?['id']?.toString() ?? '',
      name: map['name'] ?? map['part']?['name'] ?? '',
      imageUrl: map['featured_image'] ?? map['part']?['featured_image'],
      price: (map['price'] ?? map['part']?['current_price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'AED',
    );
  }

  CartItemModel copyWith({
    String? id,
    String? partId,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    double? subtotal,
    String? currency,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      currency: currency ?? this.currency,
    );
  }
}
