import 'dart:convert';

import 'package:advanced_mobile_app/utils/utils.dart';
import 'package:http/http.dart' as http;

String api = '$baseUrl/api/category';

// [GET]: /category
Future<dynamic> getMyCategoriesApi({String query = ''}) async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.get(
    Uri.parse('$api$query'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}

// [POST]: /category/create
Future<dynamic> createCategoryApi(Map<String, dynamic> data) async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.post(
    Uri.parse('$api/create'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(data),
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}

// [PUT]: /category/:id/update
Future<dynamic> updateCategoryApi(String id, Map<String, dynamic> data) async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.put(
    Uri.parse('$api/$id/update'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(data),
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}

// [DELETE]: /category/:id/delete
Future<dynamic> deleteCategoryApi(String id) async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.delete(
    Uri.parse('$api/$id/delete'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}
