import 'dart:convert';

import 'package:advanced_mobile_app/utils/utils.dart';
import 'package:http/http.dart' as http;

String api = '$baseUrl/api/settings';

// [GET]: /settings
Future<dynamic> getMySettingsApi([String query = '']) async {
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

// [GET]: /settings/extract-all-data
Future<dynamic> getAllDataToExportApi() async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.get(
    Uri.parse('$api/extract-all-data'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}

// [PUT]: /settings/update
Future<dynamic> updateMySettingsApi(Map<String, dynamic> data) async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.put(
    Uri.parse('$api/update'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(data),
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}

// [DELETE]: /settings/delete-all
Future<dynamic> deleteAllDataApi(String locale) async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.Request('DELETE', Uri.parse('$api/delete-all'))
    ..headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    })
    ..body = jsonEncode({'locale': locale});

  final streamed = await res.send();
  final body = await streamed.stream.bytesToString();

  if (streamed.statusCode >= 400) throw jsonDecode(body);
  return jsonDecode(body);
}
