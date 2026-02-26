/// Company model representing parts company
class CompanyModel {
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String? contactEmail;
  final String? contactPhone;
  final int totalParts;

  const CompanyModel({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    this.contactEmail,
    this.contactPhone,
    this.totalParts = 0,
  });

  CompanyModel copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    String? contactEmail,
    String? contactPhone,
    int? totalParts,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      totalParts: totalParts ?? this.totalParts,
    );
  }
}

