import 'dart:convert';

import 'package:advanced_mobile_app/utils/utils.dart';
import 'package:http/http.dart' as http;

final String api = '$baseUrl/api/budget';

// [GET]: /budget
Future<dynamic> getMyBudgetsApi({String query = ''}) async {
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

// [POST]: /budget/create
Future<dynamic> createBudgetApi(Map<String, dynamic> data) async {
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

// [PUT]: /budget/:id/update
Future<dynamic> updateBudgetApi(String id, Map<String, dynamic> data) async {
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

// [DELETE]: /budget/:id/delete
Future<dynamic> deleteBudgetApi(String id) async {
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
