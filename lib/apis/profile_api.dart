import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api.dart';

class ProfileApi {
  // =============== PROFILE ===============
  static Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(Uri.parse('${BaseApi.base}/profile/me/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load profile');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateProfileJson(Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('${BaseApi.base}/profile/me/'),
      headers: await BaseApi.headers,
      body: jsonEncode(body),
    );
    if (res.statusCode != 200) throw Exception('Failed to update profile');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> patchProfileJson(Map<String, dynamic> body) async {
    final req = http.Request('PATCH', Uri.parse('${BaseApi.base}/profile/me/'));
    req.headers.addAll(await BaseApi.headers);
    req.body = jsonEncode(body);
    final res = await http.Client().send(req);
    final bodyStr = await res.stream.bytesToString();
    if (res.statusCode != 200) throw Exception('Failed to patch profile');
    return jsonDecode(bodyStr) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateProfileMultipart({
    String? name,
    String? phoneNumber,
    String? address,
    String? defaultDeliveryAddress,
    String? preferredPaymentMethod,
    http.MultipartFile? profilePicture,
    bool isPatch = false,
  }) async {
    final uri = Uri.parse('${BaseApi.base}/profile/me/');
    final req = http.MultipartRequest(isPatch ? 'PATCH' : 'PUT', uri);
    final headers = await BaseApi.headersMultipart;
    req.headers.addAll(headers);
    if (name != null) req.fields['name'] = name;
    if (phoneNumber != null) req.fields['phone_number'] = phoneNumber;
    if (address != null) req.fields['address'] = address;
    if (defaultDeliveryAddress != null) req.fields['default_delivery_address'] = defaultDeliveryAddress;
    if (preferredPaymentMethod != null) req.fields['preferred_payment_method'] = preferredPaymentMethod;
    if (profilePicture != null) req.files.add(profilePicture);
    final streamed = await req.send();
    final bodyStr = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200) throw Exception('Failed to update profile');
    return jsonDecode(bodyStr) as Map<String, dynamic>;
  }
}
