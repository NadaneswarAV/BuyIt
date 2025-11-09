import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/review.dart';
import '../models/shop.dart';
import '../apis/shop_api.dart';

class DataProvider {
  Future<List<Shop>> getShops() async {
    try {
      final data = await ShopApi.getShops();
      return data.map<Shop>((json) => Shop.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Fallback to local data if API fails
      final String response = await rootBundle.loadString('assets/data/shops.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Shop.fromJson(json)).toList();
    }
  }

  Future<List<Product>> getProducts({String? shopId}) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 800));
    final String response = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> data = json.decode(response);
    List<Product> products = data.map((json) => Product.fromJson(json)).toList();

    if (shopId != null) {
      products = products.where((product) => product.shopId == shopId).toList();
    }

    return products;
  }

  Future<List<Review>> getReviews(String shopId) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 500));
    final String response = await rootBundle.loadString('assets/data/reviews.json');
    final List<dynamic> data = json.decode(response);
    List<Review> reviews = data.map((json) => Review.fromJson(json)).toList();

    return reviews.where((review) => review.shopId == shopId).toList();
  }

  // Categories: returns Map<sectionName, List<subcat maps>> to keep UI flexible and API-ready
  Future<Map<String, List<Map<String, String>>>> getCategories() async {
    final String response = await rootBundle.loadString('assets/data/categories.json');
    final Map<String, dynamic> data = json.decode(response);
    final List sections = data['sections'] as List;
    final Map<String, List<Map<String, String>>> result = {};
    for (final s in sections) {
      final String name = s['name'] as String;
      final List subs = s['subcategories'] as List;
      result[name] = subs.map<Map<String, String>>((e) => {
            'parent': e['parent'] as String,
            'title': e['title'] as String,
            'filter': e['filter'] as String,
            'image': e['image'] as String,
          }).toList();
    }
    return result;
  }

  // Profile: simple key/value map for now; easy to replace with API later
  Future<Map<String, dynamic>> getProfile() async {
    final String response = await rootBundle.loadString('assets/data/profile.json');
    final Map<String, dynamic> data = json.decode(response);
    return data;
  }

  // In a real app, this would post to a server.
  // For now, we just simulate success.
  Future<void> addReview(Review review) async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 1));
    print('Review Added (simulated): ${review.comment}');
    // Here you would typically add the review to your reviews.json or send to a backend.
  }
}