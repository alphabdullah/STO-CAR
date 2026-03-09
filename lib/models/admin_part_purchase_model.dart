/// Admin part purchase model - ecommerce order details
class AdminPartPurchaseModel {
  final String id;
  final AdminPurchaseBuyer? buyer;
  final AdminPurchaseSeller? seller;
  final AdminPurchasePart part;
  final double soldPrice;
  final int quantity;
  final double totalAmount;
  final String status;
  final String? shippingAddress;
  final String? trackingNumber;
  final DateTime purchasedAt;
  final DateTime? paidAt;

  const AdminPartPurchaseModel({
    required this.id,
    this.buyer,
    this.seller,
    required this.part,
    required this.soldPrice,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    this.shippingAddress,
    this.trackingNumber,
    required this.purchasedAt,
    this.paidAt,
  });

  factory AdminPartPurchaseModel.fromJson(Map<String, dynamic> json) {
    return AdminPartPurchaseModel(
      id: json['id']?.toString() ?? '',
      buyer: json['buyer'] != null
          ? AdminPurchaseBuyer.fromJson(
              json['buyer'] as Map<String, dynamic>,
            )
          : null,
      seller: json['seller'] != null
          ? AdminPurchaseSeller.fromJson(
              json['seller'] as Map<String, dynamic>,
            )
          : null,
      part: AdminPurchasePart.fromJson(
        json['part'] as Map<String, dynamic>,
      ),
      soldPrice: (json['sold_price'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? 'pending',
      shippingAddress: json['shipping_address']?.toString(),
      trackingNumber: json['tracking_number']?.toString(),
      purchasedAt: json['purchased_at'] != null
          ? DateTime.tryParse(json['purchased_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'].toString())
          : null,
    );
  }

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'paid':
        return 'Paid';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      default:
        return status;
    }
  }
}

class AdminPurchaseBuyer {
  final String id;
  final String name;
  final String email;
  final String? phone;

  const AdminPurchaseBuyer({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory AdminPurchaseBuyer.fromJson(Map<String, dynamic> json) {
    return AdminPurchaseBuyer(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
    );
  }
}

class AdminPurchaseSeller {
  final String id;
  final String name;
  final String email;

  const AdminPurchaseSeller({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AdminPurchaseSeller.fromJson(Map<String, dynamic> json) {
    return AdminPurchaseSeller(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

class AdminPurchasePart {
  final String id;
  final String name;
  final String? partNumber;
  final String? brand;
  final String? category;
  final String? image;

  const AdminPurchasePart({
    required this.id,
    required this.name,
    this.partNumber,
    this.brand,
    this.category,
    this.image,
  });

  factory AdminPurchasePart.fromJson(Map<String, dynamic> json) {
    return AdminPurchasePart(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      partNumber: json['part_number']?.toString(),
      brand: json['brand']?.toString(),
      category: json['category']?.toString(),
      image: json['image']?.toString(),
    );
  }
}
