import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api.dart';

class CartApi {
  // =============== CART ===============
  static Future<Map<String, dynamic>> getCart() async {
    final res = await http.get(Uri.parse('${BaseApi.base}/cart/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load cart');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> addToCart({required String shopProductId, int quantity = 1}) async {
    final res = await http.post(
      Uri.parse('${BaseApi.base}/cart/add/'),
      headers: await BaseApi.headers,
      body: jsonEncode({'shop_product_id': shopProductId, 'quantity': quantity}),
    );
    if (res.statusCode != 200) throw Exception('Failed to add to cart');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<void> checkoutCart() async {
    final res = await http.post(Uri.parse('${BaseApi.base}/cart/checkout/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Checkout failed');
  }

  static Future<void> clearCart() async {
    final res = await http.post(Uri.parse('${BaseApi.base}/cart/clear/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Clear cart failed');
  }

  static Future<int> cartCount() async {
    final res = await http.get(Uri.parse('${BaseApi.base}/cart/count/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Cart count failed');
    final data = jsonDecode(res.body);
    if (data is Map && data['count'] != null) return (data['count'] as num).toInt();
    if (data is int) return data;
    return 0;
  }

  static Future<void> removeCartItem(String itemId) async {
    final res = await http.delete(Uri.parse('${BaseApi.base}/cart/remove/$itemId/'), headers: await BaseApi.headers);
    if (res.statusCode != 204) throw Exception('Remove cart item failed');
  }

  static Future<Map<String, dynamic>> updateCartItem(String itemId, {required int quantity}) async {
    final res = await http.put(
      Uri.parse('${BaseApi.base}/cart/update/$itemId/'),
      headers: await BaseApi.headers,
      body: jsonEncode({'quantity': quantity}),
    );
    if (res.statusCode != 200) throw Exception('Update cart item failed');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
