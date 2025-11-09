import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';

class ApiService {
  static const String base = 'https://buy-it-backend-sywp.onrender.com/api';

  static Future<Map<String, String>> _headers({bool jsonBody = true}) async {
    final token = await StorageService.getString(StorageKeys.authToken);
    final headers = <String, String>{};
    if (jsonBody) headers['Content-Type'] = 'application/json';
    if (token != null && token.isNotEmpty) {
      // Default to DRF Token scheme; adjust if backend uses Bearer
      headers['Authorization'] = token.startsWith('Token ') || token.startsWith('Bearer ')
          ? token
          : 'Token $token';
    }
    return headers;
  }

  // =============== PHONE AUTH ===============
  static Future<void> requestOtp({required String phoneNumber}) async {
    final res = await http.post(
      Uri.parse('$base/phone-auth/request-otp/'),
      headers: await _headers(),
      body: jsonEncode({'phone_number': phoneNumber}),
    );
    if (res.statusCode != 200) {
      throw Exception('OTP request failed (${res.statusCode})');
    }
  }

  static Future<String> verifyOtp({required String phoneNumber, required String otp}) async {
    final res = await http.post(
      Uri.parse('$base/phone-auth/verify-otp/'),
      headers: await _headers(),
      body: jsonEncode({'phone_number': phoneNumber, 'otp': otp}),
    );
    if (res.statusCode != 200) {
      throw Exception('OTP verify failed (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final token = (data['token'] ?? data['access'] ?? data['key'] ?? '').toString();
    if (token.isEmpty) throw Exception('Token missing in response');
    await StorageService.setString(StorageKeys.authToken, token);
    return token;
  }

  // =============== PROFILE ===============
  static Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(Uri.parse('$base/profile/me/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load profile');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateProfileJson(Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$base/profile/me/'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    if (res.statusCode != 200) throw Exception('Failed to update profile');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> patchProfileJson(Map<String, dynamic> body) async {
    final req = http.Request('PATCH', Uri.parse('$base/profile/me/'));
    req.headers.addAll(await _headers());
    req.body = jsonEncode(body);
    final res = await http.Client().send(req);
    final bodyStr = await res.stream.bytesToString();
    if (res.statusCode != 200) throw Exception('Failed to patch profile');
    return jsonDecode(bodyStr) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateProfileMultipart({
    String? name,
    String? phoneNumber,
    String? address,
    String? defaultDeliveryAddress,
    String? preferredPaymentMethod,
    http.MultipartFile? profilePicture,
    bool isPatch = false,
  }) async {
    final uri = Uri.parse('$base/profile/me/');
    final req = http.MultipartRequest(isPatch ? 'PATCH' : 'PUT', uri);
    final headers = await _headers(jsonBody: false);
    req.headers.addAll(headers);
    if (name != null) req.fields['name'] = name;
    if (phoneNumber != null) req.fields['phone_number'] = phoneNumber;
    if (address != null) req.fields['address'] = address;
    if (defaultDeliveryAddress != null) req.fields['default_delivery_address'] = defaultDeliveryAddress;
    if (preferredPaymentMethod != null) req.fields['preferred_payment_method'] = preferredPaymentMethod;
    if (profilePicture != null) req.files.add(profilePicture);
    final streamed = await req.send();
    final bodyStr = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200) throw Exception('Failed to update profile');
    return jsonDecode(bodyStr) as Map<String, dynamic>;
  }

  // =============== PRODUCTS ===============
  static Future<List<dynamic>> getProducts() async {
    final res = await http.get(Uri.parse('$base/products/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load products');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getProduct(int id) async {
    final res = await http.get(Uri.parse('$base/products/$id/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load product');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<dynamic> getProductsByCategory({String? categoryName}) async {
    final uri = Uri.parse('$base/products/by-category/').replace(queryParameters: {
      if (categoryName != null && categoryName.isNotEmpty) 'category': categoryName,
    });
    final res = await http.get(uri, headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load products by category');
    return jsonDecode(res.body);
  }

  static Future<dynamic> getProductsByShop({String? shopName}) async {
    final uri = Uri.parse('$base/products/by-shop/').replace(queryParameters: {
      if (shopName != null && shopName.isNotEmpty) 'shop_name': shopName,
    });
    final res = await http.get(uri, headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load products by shop');
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> searchProducts(String q) async {
    final uri = Uri.parse('$base/products/search/').replace(queryParameters: {'q': q});
    final res = await http.get(uri, headers: await _headers());
    if (res.statusCode != 200) throw Exception('Search failed');
    return jsonDecode(res.body) as List<dynamic>;
  }

  // =============== CATEGORIES ===============
  static Future<List<dynamic>> getCategories() async {
    final res = await http.get(Uri.parse('$base/categories/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load categories');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getCategory(int id) async {
    final res = await http.get(Uri.parse('$base/categories/$id/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load category');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // =============== SHOPS ===============
  static Future<List<dynamic>> getShops() async {
    final res = await http.get(Uri.parse('$base/shops/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load shops');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getShop(int id) async {
    final res = await http.get(Uri.parse('$base/shops/$id/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load shop');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> getShopsByCategory(int categoryId) async {
    final uri = Uri.parse('$base/shops-by-category/').replace(queryParameters: {'category_id': '$categoryId'});
    final res = await http.get(uri, headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load shops by category');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<dynamic> getShopAvailability(int id) async {
    final res = await http.get(Uri.parse('$base/shops/$id/availability/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load availability');
    return jsonDecode(res.body);
  }

  static Future<dynamic> getShopCategories(int id) async {
    final res = await http.get(Uri.parse('$base/shops/$id/categories/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load shop categories');
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getShopProducts(int id) async {
    final res = await http.get(Uri.parse('$base/shops/$id/products/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load shop products');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<List<dynamic>> getShopReviews(int shopId) async {
    final res = await http.get(Uri.parse('$base/shops/$shopId/reviews/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load shop reviews');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> addShopReview(int shopId, {required int rating, required String comment}) async {
    final res = await http.post(
      Uri.parse('$base/shops/$shopId/reviews/'),
      headers: await _headers(),
      body: jsonEncode({'rating': rating, 'comment': comment}),
    );
    if (res.statusCode != 201) throw Exception('Failed to add review');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> searchShops(String q) async {
    final uri = Uri.parse('$base/shops/search/').replace(queryParameters: {'q': q});
    final res = await http.get(uri, headers: await _headers());
    if (res.statusCode != 200) throw Exception('Search shops failed');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<dynamic> getNearbyShops({required double lat, required double lng, double? radius}) async {
    final qp = <String, String>{'lat': '$lat', 'lng': '$lng'};
    if (radius != null) qp['radius'] = '$radius';
    final uri = Uri.parse('$base/shops/nearby/').replace(queryParameters: qp);
    final res = await http.get(uri, headers: await _headers());
    if (res.statusCode != 200) throw Exception('Nearby shops failed');
    return jsonDecode(res.body);
  }

  // =============== REVIEWS (by id) ===============
  static Future<Map<String, dynamic>> getReview(int id) async {
    final res = await http.get(Uri.parse('$base/reviews/$id/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load review');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateReview(int id, {required int rating, required String comment, bool patch = false}) async {
    final uri = Uri.parse('$base/reviews/$id/');
    final body = jsonEncode({'rating': rating, 'comment': comment});
    if (patch) {
      final req = http.Request('PATCH', uri);
      req.headers.addAll(await _headers());
      req.body = body;
      final res = await http.Client().send(req);
      final bodyStr = await res.stream.bytesToString();
      if (res.statusCode != 200) throw Exception('Failed to patch review');
      return jsonDecode(bodyStr) as Map<String, dynamic>;
    } else {
      final res = await http.put(uri, headers: await _headers(), body: body);
      if (res.statusCode != 200) throw Exception('Failed to update review');
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
  }

  static Future<void> deleteReview(int id) async {
    final res = await http.delete(Uri.parse('$base/reviews/$id/'), headers: await _headers());
    if (res.statusCode != 204) throw Exception('Failed to delete review');
  }

  // =============== WISHLIST ===============
  static Future<Map<String, dynamic>> addToWishlist({required String wishlistType, int? productId, int? shopId}) async {
    final body = <String, dynamic>{'wishlist_type': wishlistType};
    if (productId != null) body['product_id'] = productId;
    if (shopId != null) body['shop_id'] = shopId;
    final res = await http.post(Uri.parse('$base/add-to-wishlist/'), headers: await _headers(), body: jsonEncode(body));
    if (res.statusCode != 201) throw Exception('Failed to add to wishlist');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> allWishlist() async {
    final res = await http.get(Uri.parse('$base/all-wishlist/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load wishlist');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<void> removeFromWishlist({int? productId, int? shopId}) async {
    final qp = <String, String>{};
    if (productId != null) qp['product_id'] = '$productId';
    if (shopId != null) qp['shop_id'] = '$shopId';
    final uri = Uri.parse('$base/remove-from-wishlist/').replace(queryParameters: qp);
    final res = await http.delete(uri, headers: await _headers());
    if (res.statusCode != 204) throw Exception('Failed to remove from wishlist');
  }

  // =============== CART ===============
  static Future<Map<String, dynamic>> getCart() async {
    final res = await http.get(Uri.parse('$base/cart/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load cart');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> addToCart({required String shopProductId, int quantity = 1}) async {
    final res = await http.post(
      Uri.parse('$base/cart/add/'),
      headers: await _headers(),
      body: jsonEncode({'shop_product_id': shopProductId, 'quantity': quantity}),
    );
    if (res.statusCode != 200) throw Exception('Failed to add to cart');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<void> checkoutCart() async {
    final res = await http.post(Uri.parse('$base/cart/checkout/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Checkout failed');
  }

  static Future<void> clearCart() async {
    final res = await http.post(Uri.parse('$base/cart/clear/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Clear cart failed');
  }

  static Future<int> cartCount() async {
    final res = await http.get(Uri.parse('$base/cart/count/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Cart count failed');
    final data = jsonDecode(res.body);
    if (data is Map && data['count'] != null) return (data['count'] as num).toInt();
    if (data is int) return data;
    return 0;
  }

  static Future<void> removeCartItem(String itemId) async {
    final res = await http.delete(Uri.parse('$base/cart/remove/$itemId/'), headers: await _headers());
    if (res.statusCode != 204) throw Exception('Remove cart item failed');
  }

  static Future<Map<String, dynamic>> updateCartItem(String itemId, {required int quantity}) async {
    final res = await http.put(
      Uri.parse('$base/cart/update/$itemId/'),
      headers: await _headers(),
      body: jsonEncode({'quantity': quantity}),
    );
    if (res.statusCode != 200) throw Exception('Update cart item failed');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // =============== ORDERS ===============
  static Future<List<dynamic>> getOrders() async {
    final res = await http.get(Uri.parse('$base/orders/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load orders');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getOrder(String id) async {
    final res = await http.get(Uri.parse('$base/orders/$id/'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load order');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // =============== SCHEMA (optional) ===============
  static Future<dynamic> getSchema({String? format, String? lang}) async {
    final uri = Uri.parse('$base/schema/').replace(queryParameters: {
      if (format != null) 'format': format,
      if (lang != null) 'lang': lang,
    });
    final res = await http.get(uri, headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to load schema');
    return jsonDecode(res.body);
  }
}
