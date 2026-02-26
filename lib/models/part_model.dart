/// Part model representing auto part - Matched with sto_car backend
class PartModel {
  final String id;
  final String companyId;
  final String companyName;
  final String? companyLogo;
  final String name;
  final String description;
  final String category;
  final String? subCategory;
  final String condition; // new, used, refurbished
  final double price;
  final double? salePrice;
  final double currentPrice;
  final String? brand;
  final String? partNumber;
  final String? oemNumber;
  final int? yearFrom;
  final int? yearTo;
  final String? location;
  final List<String> images;
  final String currency;
  final int stockQuantity;
  final String? imageUrl;
  final bool isFeatured;
  final int? discountPercentage;
  final String? compatibleMake;
  final String? compatibleModel;
  final Map<String, dynamic>? specifications;
  final DateTime createdAt;
  final String? createdBy;

  const PartModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    this.companyLogo,
    required this.name,
    required this.description,
    required this.category,
    this.subCategory,
    required this.condition,
    required this.price,
    this.salePrice,
    required this.currentPrice,
    this.brand,
    this.partNumber,
    this.oemNumber,
    this.yearFrom,
    this.yearTo,
    this.location,
    this.images = const [],
    this.currency = 'AED',
    this.stockQuantity = 0,
    this.imageUrl,
    this.isFeatured = false,
    this.discountPercentage,
    this.compatibleMake,
    this.compatibleModel,
    this.specifications,
    required this.createdAt,
    this.createdBy,
  });

  bool get isInStock => stockQuantity > 0;
  bool get isOutOfStock => stockQuantity == 0;
  bool get hasDiscount => salePrice != null && salePrice! < price;

  PartModel copyWith({
    String? id,
    String? companyId,
    String? companyName,
    String? companyLogo,
    String? name,
    String? description,
    String? category,
    String? subCategory,
    String? condition,
    double? price,
    double? salePrice,
    double? currentPrice,
    String? brand,
    String? partNumber,
    String? oemNumber,
    int? yearFrom,
    int? yearTo,
    String? location,
    List<String>? images,
    String? currency,
    int? stockQuantity,
    String? imageUrl,
    bool? isFeatured,
    int? discountPercentage,
    String? compatibleMake,
    String? compatibleModel,
    Map<String, dynamic>? specifications,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return PartModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      companyLogo: companyLogo ?? this.companyLogo,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      condition: condition ?? this.condition,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      brand: brand ?? this.brand,
      partNumber: partNumber ?? this.partNumber,
      oemNumber: oemNumber ?? this.oemNumber,
      yearFrom: yearFrom ?? this.yearFrom,
      yearTo: yearTo ?? this.yearTo,
      location: location ?? this.location,
      images: images ?? this.images,
      currency: currency ?? this.currency,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      compatibleMake: compatibleMake ?? this.compatibleMake,
      compatibleModel: compatibleModel ?? this.compatibleModel,
      specifications: specifications ?? this.specifications,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  factory PartModel.fromMap(Map<String, dynamic> map) {
    return PartModel(
      id: map['id']?.toString() ?? '',
      companyId:
          map['company']?['id']?.toString() ??
          map['company_id']?.toString() ??
          '',
      companyName:
          map['company']?['name'] ?? map['company_name'] ?? 'Unknown Seller',
      companyLogo: map['company']?['logo'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      subCategory: map['sub_category'],
      condition: map['condition'] ?? 'new',
      price: (map['price'] ?? 0.0).toDouble(),
      salePrice: map['sale_price'] != null
          ? (map['sale_price'] as num).toDouble()
          : null,
      currentPrice: (map['current_price'] ?? map['price'] ?? 0.0).toDouble(),
      brand: map['brand'],
      partNumber: map['part_number'],
      oemNumber: map['oem_number'],
      yearFrom: map['compatible_year_from'],
      yearTo: map['compatible_year_to'],
      location: map['location'],
      images: map['images'] != null ? List<String>.from(map['images']) : [],
      currency: map['currency'] ?? 'AED',
      stockQuantity: map['quantity'] ?? map['stock_quantity'] ?? 0,
      imageUrl: map['featured_image'] ?? map['image_url'],
      isFeatured: map['is_featured'] ?? false,
      discountPercentage: map['discount_percentage'],
      compatibleMake: map['compatible_make'],
      compatibleModel: map['compatible_model'],
      specifications: map['specifications'] is Map<String, dynamic>
          ? map['specifications']
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      createdBy: map['creator']?['name'] ?? map['created_by']?.toString(),
    );
  }
}
