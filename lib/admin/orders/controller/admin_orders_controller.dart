import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/admin_part_purchase_model.dart';
import '../../../services/admin_service.dart';

/// Admin part purchases / orders controller (ecommerce orders)
class AdminOrdersController extends GetxController {
  final AdminService _adminService = AdminService();
  final _purchases = <AdminPartPurchaseModel>[].obs;
  final _isLoading = false.obs;
  final _currentPage = 1.obs;
  final _lastPage = 1.obs;
  final _total = 0.obs;
  String? _statusFilter;
  String? _searchQuery;

  List<AdminPartPurchaseModel> get purchases => _purchases;
  bool get isLoading => _isLoading.value;
  int get currentPage => _currentPage.value;
  int get lastPage => _lastPage.value;
  int get total => _total.value;
  bool get hasMore => _currentPage.value < _lastPage.value;
  String? get statusFilter => _statusFilter;

  @override
  void onInit() {
    super.onInit();
    loadPurchases();
  }

  Future<void> loadPurchases({bool refresh = false}) async {
    if (refresh) _currentPage.value = 1;
    _isLoading.value = true;
    try {
      final result = await _adminService.getPartPurchases(
        page: _currentPage.value,
        status: _statusFilter,
        search: _searchQuery,
      );
      final data = result['data'] as List<dynamic>;
      final meta = result['meta'] as Map<String, dynamic>? ?? {};
      final list = data
          .map((e) =>
              AdminPartPurchaseModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (refresh) {
        _purchases.value = list;
      } else {
        _purchases.addAll(list);
      }
      _currentPage.value = (meta['current_page'] as num?)?.toInt() ?? 1;
      _lastPage.value = (meta['last_page'] as num?)?.toInt() ?? 1;
      _total.value = (meta['total'] as num?)?.toInt() ?? 0;
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (_isLoading.value || !hasMore) return;
    _currentPage.value++;
    await loadPurchases(refresh: false);
  }

  void setStatusFilter(String? status) {
    _statusFilter = status;
    loadPurchases(refresh: true);
  }

  void setSearch(String? query) {
    _searchQuery = query?.trim().isEmpty == true ? null : query;
    loadPurchases(refresh: true);
  }

  Future<void> reload() => loadPurchases(refresh: true);
}
