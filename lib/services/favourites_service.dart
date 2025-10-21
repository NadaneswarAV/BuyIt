import 'dart:convert';
import '../services/storage_service.dart';

class FavouritesService {
  static const String _favKey = 'favourites_json';

  static Future<List<Map<String, dynamic>>> load() async {
    final saved = await StorageService.getString(_favKey);
    if (saved == null || saved.isEmpty) return <Map<String, dynamic>>[];
    final List<dynamic> data = json.decode(saved);
    return data.cast<Map<String, dynamic>>();
  }

  static Future<void> save(List<Map<String, dynamic>> favs) async {
    await StorageService.setString(_favKey, json.encode(favs));
  }

  static Future<void> addShop({
    required String store,
    double? rating,
    String? distance,
  }) async {
    final list = await load();
    list.insert(0, {
      'type': 'shop',
      'store': store,
      'rating': rating ?? 0.0,
      'distance': distance ?? '',
    });
    await save(list);
  }

  static Future<void> addItem({
    String? store,
    required String product,
    double? price,
    String? unit,
    double? rating,
    String? distance,
    String? subtitle,
  }) async {
    final list = await load();
    list.insert(0, {
      'type': 'item',
      'store': store ?? '-',
      'product': product,
      'subtitle': subtitle ?? '',
      'price': price ?? 0.0,
      'unit': (unit == null || unit.isEmpty) ? 'pc' : unit,
      'rating': rating ?? 0.0,
      'distance': distance ?? '',
    });
    await save(list);
  }

  static Future<bool> isShopFavouritedByName(String store) async {
    final list = await load();
    return list.any((e) => e['type'] == 'shop' && (e['store'] ?? '').toString().toLowerCase() == store.toLowerCase());
  }

  static Future<bool> isItemFavouritedByProduct(String product) async {
    final list = await load();
    return list.any((e) => e['type'] == 'item' && (e['product'] ?? '').toString().toLowerCase() == product.toLowerCase());
  }

  static Future<void> removeShopByName(String store) async {
    final list = await load();
    list.removeWhere((e) => e['type'] == 'shop' && (e['store'] ?? '').toString().toLowerCase() == store.toLowerCase());
    await save(list);
  }

  static Future<void> removeItemByProduct(String product) async {
    final list = await load();
    list.removeWhere((e) => e['type'] == 'item' && (e['product'] ?? '').toString().toLowerCase() == product.toLowerCase());
    await save(list);
  }
}
