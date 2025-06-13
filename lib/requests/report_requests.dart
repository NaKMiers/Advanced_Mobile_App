import 'dart:convert';

import 'package:advanced_mobile_app/utils/utils.dart';
import 'package:http/http.dart' as http;

String api = '$baseUrl/api/report';

// [POST]: /report/add
Future<dynamic> sendReportApi(List<dynamic> results) async {
  print(results);
  print('Sending report to $api/add');

  final res = await http.post(
    Uri.parse('$api/add'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'results': results}),
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}
