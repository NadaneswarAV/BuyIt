import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api.dart';

class CategoryApi {
  // =============== CATEGORIES ===============
  static Future<List<dynamic>> getCategories() async {
    final res = await http.get(Uri.parse('${BaseApi.base}/categories/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load categories');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getCategory(int id) async {
    final res = await http.get(Uri.parse('${BaseApi.base}/categories/$id/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load category');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
