import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shop.dart';

class ShopService {
  static const String baseUrl = 'https://buy-it-backend-sywp.onrender.com/api';

  static Future<List<Shop>> fetchShops() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/shops/'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Shop.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load shops');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
