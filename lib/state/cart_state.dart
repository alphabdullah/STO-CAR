import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../services/cart_service.dart';
import '../core/api/api_client.dart';

/// Cart state management - syncs with backend
class CartState extends GetxController {
  final CartService _cartService = CartService();

  final RxList<CartItemModel> items = <CartItemModel>[].obs;
  final RxDouble subtotal = 0.0.obs;
  final RxInt itemCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await _cartService.getCart();
      items.assignAll(data['items'] as List<CartItemModel>);
      subtotal.value = data['subtotal'] as double;
      itemCount.value = data['item_count'] as int;
    } on ApiException catch (e) {
      error.value = e.message;
      items.clear();
      subtotal.value = 0;
      itemCount.value = 0;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addToCart(String partId, {int quantity = 1}) async {
    try {
      error.value = '';
      await _cartService.addToCart(partId: partId, quantity: quantity);
      await fetchCart();
      return true;
    } on ApiException catch (e) {
      error.value = e.message;
      return false;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }

  Future<bool> updateQuantity(String cartItemId, int quantity) async {
    try {
      error.value = '';
      await _cartService.updateQuantity(cartItemId, quantity);
      await fetchCart();
      return true;
    } on ApiException catch (e) {
      error.value = e.message;
      return false;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }

  Future<bool> removeFromCart(String cartItemId) async {
    try {
      error.value = '';
      await _cartService.removeFromCart(cartItemId);
      await fetchCart();
      return true;
    } on ApiException catch (e) {
      error.value = e.message;
      return false;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }

  Future<Map<String, dynamic>?> checkout(String shippingAddress) async {
    try {
      error.value = '';
      return await _cartService.checkout(shippingAddress);
    } on ApiException catch (e) {
      error.value = e.message;
      return null;
    } catch (e) {
      error.value = e.toString();
      return null;
    }
  }
}
