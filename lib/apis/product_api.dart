import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api.dart';

class ProductApi {
  // =============== PRODUCTS ===============
  static Future<List<dynamic>> getProducts() async {
    final res = await http.get(Uri.parse('${BaseApi.base}/products/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load products');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getProduct(int id) async {
    final res = await http.get(Uri.parse('${BaseApi.base}/products/$id/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load product');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<dynamic> getProductsByCategory({String? categoryName}) async {
    final uri = Uri.parse('${BaseApi.base}/products/by-category/').replace(queryParameters: {
      if (categoryName != null && categoryName.isNotEmpty) 'category': categoryName,
    });
    final res = await http.get(uri, headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load products by category');
    return jsonDecode(res.body);
  }

  static Future<dynamic> getProductsByShop({String? shopName}) async {
    final uri = Uri.parse('${BaseApi.base}/products/by-shop/').replace(queryParameters: {
      if (shopName != null && shopName.isNotEmpty) 'shop_name': shopName,
    });
    final res = await http.get(uri, headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load products by shop');
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> searchProducts(String q) async {
    final uri = Uri.parse('${BaseApi.base}/products/search/').replace(queryParameters: {'q': q});
    final res = await http.get(uri, headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Search failed');
    return jsonDecode(res.body) as List<dynamic>;
  }
}
