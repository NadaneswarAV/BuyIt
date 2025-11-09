import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api.dart';

class WishlistApi {
  // =============== WISHLIST ===============
  static Future<Map<String, dynamic>> addToWishlist({required String wishlistType, int? productId, int? shopId}) async {
    final body = <String, dynamic>{'wishlist_type': wishlistType};
    if (productId != null) body['product_id'] = productId;
    if (shopId != null) body['shop_id'] = shopId;
    final res = await http.post(Uri.parse('${BaseApi.base}/add-to-wishlist/'), headers: await BaseApi.headers, body: jsonEncode(body));
    if (res.statusCode != 201) throw Exception('Failed to add to wishlist');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> allWishlist() async {
    final res = await http.get(Uri.parse('${BaseApi.base}/all-wishlist/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load wishlist');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<void> removeFromWishlist({int? productId, int? shopId}) async {
    final qp = <String, String>{};
    if (productId != null) qp['product_id'] = '$productId';
    if (shopId != null) qp['shop_id'] = '$shopId';
    final uri = Uri.parse('${BaseApi.base}/remove-from-wishlist/').replace(queryParameters: qp);
    final res = await http.delete(uri, headers: await BaseApi.headers);
    if (res.statusCode != 204) throw Exception('Failed to remove from wishlist');
  }
}
