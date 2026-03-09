import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../models/cart_item_model.dart';

/// Cart Service - API calls for cart operations
class CartService {
  CartService._();

  static final CartService _instance = CartService._();
  factory CartService() => _instance;

  final ApiClient _api = ApiClient();

  /// Get cart items
  Future<Map<String, dynamic>> getCart() async {
    final res = await _api.get(ApiEndpoints.getCart, requiresAuth: true);
    if (res['success'] != true) throw ApiException(res['message'] ?? 'Failed to load cart');

    final data = res['data'] as Map<String, dynamic>? ?? {};
    final rawItems = data['items'] ?? [];
    final list = rawItems is List ? rawItems : [];
    return {
      'items': list.map((e) => CartItemModel.fromMap(e is Map<String, dynamic> ? e : {})).toList(),
      'subtotal': (data['subtotal'] ?? 0).toDouble(),
      'item_count': data['item_count'] ?? 0,
    };
  }

  /// Add part to cart
  Future<CartItemModel> addToCart({required String partId, int quantity = 1}) async {
    final res = await _api.post(
      ApiEndpoints.addToCart,
      body: {'part_id': partId, 'quantity': quantity},
      requiresAuth: true,
    );
    if (res['success'] != true) throw ApiException(res['message'] ?? 'Failed to add to cart');
    return CartItemModel.fromMap(res['data'] ?? {});
  }

  /// Update cart item quantity
  Future<CartItemModel> updateQuantity(String cartItemId, int quantity) async {
    final res = await _api.put(
      ApiEndpoints.updateCartItem(cartItemId),
      body: {'quantity': quantity},
      requiresAuth: true,
    );
    if (res['success'] != true) throw ApiException(res['message'] ?? 'Failed to update');
    return CartItemModel.fromMap(res['data'] ?? {});
  }

  /// Remove from cart
  Future<void> removeFromCart(String cartItemId) async {
    final res = await _api.delete(
      ApiEndpoints.removeFromCart(cartItemId),
      requiresAuth: true,
    );
    if (res['success'] != true) throw ApiException(res['message'] ?? 'Failed to remove');
  }

  /// Checkout cart
  Future<Map<String, dynamic>> checkout(String shippingAddress) async {
    final res = await _api.post(
      ApiEndpoints.cartCheckout,
      body: {'shipping_address': shippingAddress},
      requiresAuth: true,
    );
    if (res['success'] != true) throw ApiException(res['message'] ?? 'Checkout failed');
    return {
      'total_amount': (res['data']?['total_amount'] ?? 0).toDouble(),
      'items_purchased': res['data']?['items_purchased'] ?? 0,
    };
  }
}
