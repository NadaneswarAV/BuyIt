import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/shop.dart';

class DataProvider {
  Future<List<Shop>> getShops() async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 1));
    final String response = await rootBundle.loadString('assets/data/shops.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Shop.fromJson(json)).toList();
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

  // In a real app, this would post to a server.
  // For now, we just simulate success.
  Future<void> addReview(Review review) async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 1));
    print('Review Added (simulated): ${review.comment}');
    // Here you would typically add the review to your reviews.json or send to a backend.
  }
}