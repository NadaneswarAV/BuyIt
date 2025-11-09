import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';

class BaseApi {
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

  static Future<Map<String, String>> get headers async => await _headers();
  static Future<Map<String, String>> get headersMultipart async => await _headers(jsonBody: false);
}
