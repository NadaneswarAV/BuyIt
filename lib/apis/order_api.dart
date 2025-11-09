import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api.dart';

class OrderApi {
  // =============== ORDERS ===============
  static Future<List<dynamic>> getOrders() async {
    final res = await http.get(Uri.parse('${BaseApi.base}/orders/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load orders');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getOrder(String id) async {
    final res = await http.get(Uri.parse('${BaseApi.base}/orders/$id/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load order');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
