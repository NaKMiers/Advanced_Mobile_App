import 'dart:convert';

import 'package:advanced_mobile_app/utils/utils.dart';
import 'package:http/http.dart' as http;

String api = '$baseUrl/api/transaction';

// [GET]: /transaction
Future<dynamic> getMyTransactionsApi([String query = '']) async {
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

// [GET]: /transaction/history
Future<dynamic> getHistoryApi([String query = '']) async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.get(
    Uri.parse('$api/history$query'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}

// [POST]: /transaction/create
Future<dynamic> createTransactionApi(Map<String, dynamic> data) async {
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

// [PUT]: /transaction/:id/update
Future<dynamic> updateTransactionApi(
  String id,
  Map<String, dynamic> data,
) async {
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

// [DELETE]: /transaction/:id/delete
Future<dynamic> deleteTransactionApi(String id) async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final request = http.Request('DELETE', Uri.parse('$api/$id/delete'))
    ..headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

  final response = await request.send();
  final body = await response.stream.bytesToString();

  if (response.statusCode >= 400) throw jsonDecode(body);
  return jsonDecode(body);
}
