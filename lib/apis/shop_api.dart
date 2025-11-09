import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api.dart';

class ShopApi {
  // =============== SHOPS ===============
  static Future<List<dynamic>> getShops() async {
    final res = await http.get(Uri.parse('${BaseApi.base}/shops/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load shops');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<dynamic> getProductsByShop({String? shopName}) async {
    final uri = Uri.parse('${BaseApi.base}/products/by-shop/').replace(queryParameters: {
      if (shopName != null && shopName.isNotEmpty) 'shop_name': shopName,
    });
    final res = await http.get(uri, headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load products by shop');
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getShop(int id) async {
    final res = await http.get(Uri.parse('${BaseApi.base}/shops/$id/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load shop');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> getShopsByCategory(int categoryId) async {
    final uri = Uri.parse('${BaseApi.base}/shops-by-category/').replace(queryParameters: {'category_id': '$categoryId'});
    final res = await http.get(uri, headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load shops by category');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<dynamic> getShopAvailability(int id) async {
    final res = await http.get(Uri.parse('${BaseApi.base}/shops/$id/availability/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load availability');
    return jsonDecode(res.body);
  }

  static Future<dynamic> getShopCategories(int id) async {
    final res = await http.get(Uri.parse('${BaseApi.base}/shops/$id/categories/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load shop categories');
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getShopProducts(int id) async {
    final res = await http.get(Uri.parse('${BaseApi.base}/shops/$id/products/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load shop products');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<List<dynamic>> getShopReviews(int shopId) async {
    final res = await http.get(Uri.parse('${BaseApi.base}/shops/$shopId/reviews/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load shop reviews');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> addShopReview(int shopId, {required int rating, required String comment}) async {
    final res = await http.post(
      Uri.parse('${BaseApi.base}/shops/$shopId/reviews/'),
      headers: await BaseApi.headers,
      body: jsonEncode({'rating': rating, 'comment': comment}),
    );
    if (res.statusCode != 201) throw Exception('Failed to add review');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> searchShops(String q) async {
    final uri = Uri.parse('${BaseApi.base}/shops/search/').replace(queryParameters: {'q': q});
    final res = await http.get(uri, headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Search shops failed');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<dynamic> getNearbyShops({required double lat, required double lng, double? radius}) async {
    final qp = <String, String>{'lat': '$lat', 'lng': '$lng'};
    if (radius != null) qp['radius'] = '$radius';
    final uri = Uri.parse('${BaseApi.base}/shops/nearby/').replace(queryParameters: qp);
    final res = await http.get(uri, headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Nearby shops failed');
    return jsonDecode(res.body);
  }
}
