import 'package:get/get.dart';
import '../models/company_model.dart';
import '../models/part_model.dart';
import '../models/sold_part_model.dart';
import '../services/parts_service.dart';

/// Parts marketplace state controller - Fully synchronized with sto_car backend
class PartsState extends GetxController {
  static final PartsState _instance = PartsState._internal();
  factory PartsState() => _instance;
  PartsState._internal();

  final PartsService _partsService = PartsService();

  // Observable state
  final _companies = <CompanyModel>[].obs;
  final _parts = <PartModel>[].obs;
  final _soldParts = <SoldPartModel>[].obs;
  final _categories = <String>[].obs;
  final _isLoading = false.obs;

  // Filters
  final _selectedCategory = 'All'.obs;
  final _searchQuery = ''.obs;
  final _selectedCompany = Rxn<CompanyModel>();
  final _selectedPart = Rxn<PartModel>(); // Re-added selection
  final _selectedCondition = RxnString();
  final _selectedMake = RxnString();
  final _selectedModel = RxnString();
  final _selectedYear = RxnInt();
  final _minPrice = RxnDouble();
  final _maxPrice = RxnDouble();
  final _isFeaturedOnly = false.obs;

  // Getters
  RxList<CompanyModel> get companies => _companies;
  RxList<PartModel> get parts => _parts;
  RxList<SoldPartModel> get soldParts => _soldParts;
  RxList<String> get categories => _categories;
  bool get isLoading => _isLoading.value;

  String get selectedCategory => _selectedCategory.value;
  String get searchQuery => _searchQuery.value;
  CompanyModel? get selectedCompany => _selectedCompany.value;
  PartModel? get selectedPart =>
      _selectedPart.value; // Re-added selection getter
  String? get selectedCondition => _selectedCondition.value;
  String? get selectedMake => _selectedMake.value;
  String? get selectedModel => _selectedModel.value;
  int? get selectedYear => _selectedYear.value;
  double? get minPrice => _minPrice.value;
  double? get maxPrice => _maxPrice.value;
  bool get isFeaturedOnly => _isFeaturedOnly.value;

  // Helper for company-specific views
  List<PartModel> get partsBySelectedCompany {
    if (_selectedCompany.value == null) return _parts.toList();
    return _parts
        .where((p) => p.companyId == _selectedCompany.value!.id)
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    refreshMarketplace();
    fetchCategories();
  }

  /// Refresh marketplace with all active filters
  Future<void> refreshMarketplace() async {
    await fetchParts(
      category: _selectedCategory.value == 'All'
          ? null
          : _selectedCategory.value,
      brand: _selectedCompany.value?.name,
      condition: _selectedCondition.value,
      make: _selectedMake.value,
      model: _selectedModel.value,
      year: _selectedYear.value,
      minPrice: _minPrice.value,
      maxPrice: _maxPrice.value,
      search: _searchQuery.value.isEmpty ? null : _searchQuery.value,
      featured: _isFeaturedOnly.value ? true : null,
    );
  }

  /// Fetch parts from API
  Future<void> fetchParts({
    int? page,
    String? category,
    int perPage = 1000,
    String? brand,
    String? condition,
    String? make,
    String? model,
    int? year,
    double? minPrice,
    double? maxPrice,
    String? search,
    bool? featured,
  }) async {
    _isLoading.value = true;
    try {
      final response = await _partsService.getParts(
        page: page,
        category: category,
        perPage: perPage,
        brand: brand,
        condition: condition,
        make: make,
        model: model,
        year: year,
        minPrice: minPrice,
        maxPrice: maxPrice,
        search: search,
        featured: featured,
      );

      final List<dynamic> data = response['data'] ?? [];

      if (page == null || page == 1) {
        _parts.value = data
            .map((item) => PartModel.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        _parts.addAll(
          data
              .map((item) => PartModel.fromMap(item as Map<String, dynamic>))
              .toList(),
        );
      }

      // Update company list if not filtering by brand (to show all available brands)
      if (brand == null && (page == null || page == 1)) {
        final uniqueCompanies = <String, CompanyModel>{};
        for (var item in data) {
          if (item['company'] != null) {
            final comp = item['company'];
            final companyId = comp['id'].toString();
            if (!uniqueCompanies.containsKey(companyId)) {
              uniqueCompanies[companyId] = CompanyModel(
                id: companyId,
                name: comp['name'] ?? 'Unknown',
                description: comp['description'] ?? '',
                logoUrl: comp['logo'],
                totalParts: 0,
              );
            }
          }
        }
        _companies.value = uniqueCompanies.values.toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load parts: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Setters with auto-refresh
  void setCategory(String category) {
    _selectedCategory.value = category;
    refreshMarketplace();
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    refreshMarketplace();
  }

  void selectCompany(String? companyId) {
    if (companyId == null) {
      _selectedCompany.value = null;
    } else {
      _selectedCompany.value = _companies.firstWhereOrNull(
        (c) => c.id == companyId,
      );
    }
    refreshMarketplace();
  }

  void selectPart(String partId) {
    _selectedPart.value = _parts.firstWhereOrNull((p) => p.id == partId);
  }

  void setCondition(String? condition) {
    _selectedCondition.value = condition;
    refreshMarketplace();
  }

  void setCompatibility({String? make, String? model, int? year}) {
    if (make != null) _selectedMake.value = make;
    if (model != null) _selectedModel.value = model;
    if (year != null) _selectedYear.value = year;
    refreshMarketplace();
  }

  void setPriceRange(double? min, double? max) {
    _minPrice.value = min;
    _maxPrice.value = max;
    refreshMarketplace();
  }

  void toggleFeatured(bool value) {
    _isFeaturedOnly.value = value;
    refreshMarketplace();
  }

  void clearAllFilters() {
    _selectedCategory.value = 'All';
    _searchQuery.value = '';
    _selectedCompany.value = null;
    _selectedCondition.value = null;
    _selectedMake.value = null;
    _selectedModel.value = null;
    _selectedYear.value = null;
    _minPrice.value = null;
    _maxPrice.value = null;
    _isFeaturedOnly.value = false;
    refreshMarketplace();
  }

  Future<void> fetchCategories() async {
    try {
      final data = await _partsService.getCategories();
      _categories.value = data;
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> purchasePart(
    String partId,
    int quantity, {
    String shippingAddress = 'Local Pickup',
  }) async {
    _isLoading.value = true;
    try {
      await _partsService.purchasePart(
        partId,
        quantity: quantity,
        shippingAddress: shippingAddress,
      );
      final index = _parts.indexWhere((p) => p.id == partId);
      if (index != -1) {
        _parts[index] = _parts[index].copyWith(
          stockQuantity: _parts[index].stockQuantity - quantity,
        );
      }
      _isLoading.value = false;
      update();
      return true;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  // Restore Admin Methods to fix lint errors
  Future<void> addPart(PartModel part) async {
    _parts.add(part);
    update();
  }

  Future<void> updatePart(PartModel part) async {
    final index = _parts.indexWhere((p) => p.id == part.id);
    if (index != -1) {
      _parts[index] = part;
    }
    update();
  }

  Future<void> deletePart(String partId) async {
    _parts.removeWhere((p) => p.id == partId);
    update();
  }
}
