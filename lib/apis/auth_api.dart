import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api.dart';
import '../services/storage_service.dart';

class AuthApi {
  // =============== PHONE AUTH ===============
  static Future<void> requestOtp({required String phoneNumber}) async {
    final res = await http.post(
      Uri.parse('${BaseApi.base}/phone-auth/request-otp/'),
      headers: await BaseApi.headers,
      body: jsonEncode({'phone_number': phoneNumber}),
    );
    if (res.statusCode != 200) {
      throw Exception('OTP request failed (${res.statusCode})');
    }
  }

  static Future<String> verifyOtp({required String phoneNumber, required String otp}) async {
    final res = await http.post(
      Uri.parse('${BaseApi.base}/phone-auth/verify-otp/'),
      headers: await BaseApi.headers,
      body: jsonEncode({'phone_number': phoneNumber, 'otp': otp}),
    );
    if (res.statusCode != 200) {
      throw Exception('OTP verify failed (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final token = (data['token'] ?? data['access'] ?? data['key'] ?? '').toString();
    if (token.isEmpty) throw Exception('Token missing in response');
    await StorageService.setString(StorageKeys.authToken, token);
    return token;
  }
}
