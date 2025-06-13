import 'dart:convert';

import 'package:advanced_mobile_app/utils/utils.dart';
import 'package:http/http.dart' as http;

export 'auth_requests.dart' hide api;
export 'budget_requests.dart' hide api;
export 'category_requests.dart' hide api;
export 'report_requests.dart' hide api;
export 'settings_requests.dart' hide api;
export 'transaction_requests.dart' hide api;
export 'user_requests.dart' hide api;
export 'wallet_requests.dart' hide api;

final String api = '$baseUrl/api';

// [GET]: /
Future<dynamic> initApi() async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.get(
    Uri.parse(api),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}
