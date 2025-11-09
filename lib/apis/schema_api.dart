import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api.dart';

class SchemaApi {
  // =============== SCHEMA (optional) ===============
  static Future<dynamic> getSchema({String? format, String? lang}) async {
    final uri = Uri.parse('${BaseApi.base}/schema/').replace(queryParameters: {
      if (format != null) 'format': format,
      if (lang != null) 'lang': lang,
    });
    final res = await http.get(uri, headers: await BaseApi.headers);
    if (res.statusCode != 200) throw Exception('Failed to load schema');
    return jsonDecode(res.body);
  }
}
