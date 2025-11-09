import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api.dart';

class ReviewApi {
  // =============== REVIEWS (by id) ===============
  static Future<Map<String, dynamic>> getReview(int id) async {
    final res = await http.get(Uri.parse('${BaseApi.base}/reviews/$id/'), headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load review');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateReview(int id, {required int rating, required String comment, bool patch = false}) async {
    final uri = Uri.parse('${BaseApi.base}/reviews/$id/');
    final body = jsonEncode({'rating': rating, 'comment': comment});
    if (patch) {
      final req = http.Request('PATCH', uri);
      req.headers.addAll(await BaseApi.headers);
      req.body = body;
      final res = await http.Client().send(req);
      final bodyStr = await res.stream.bytesToString();
      if (res.statusCode != 200) throw Exception('Failed to patch review');
      return jsonDecode(bodyStr) as Map<String, dynamic>;
    } else {
      final res = await http.put(uri, headers: await BaseApi.headers, body: body);
      if (res.statusCode != 200) throw Exception('Failed to update review');
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
  }

  static Future<void> deleteReview(int id) async {
    final res = await http.delete(Uri.parse('${BaseApi.base}/reviews/$id/'), headers: await BaseApi.headers);
    if (res.statusCode != 204) throw Exception('Failed to delete review');
  }
}
