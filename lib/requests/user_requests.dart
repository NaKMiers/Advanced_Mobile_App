import 'dart:convert';
import 'dart:io' show Platform;

import 'package:advanced_mobile_app/utils/utils.dart';
import 'package:http/http.dart' as http;

String api = '$baseUrl/api/user';

// [GET]: /user/refresh-token
Future<dynamic> refreshTokenApi() async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.get(
    Uri.parse('$api/refresh-token'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}

// [GET]: /user/stats
Future<dynamic> getUserStatsApi([String query = '']) async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.get(
    Uri.parse('$api/stats$query'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}

// [POST]: /user/referral-code
Future<dynamic> applyReferralCodeApi(String code) async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.post(
    Uri.parse('$api/referral-code'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'code': code,
      'platform': Platform.isIOS ? 'ios' : 'android',
    }),
  );

  if (res.statusCode >= 400) throw jsonDecode(res.body);
  return jsonDecode(res.body);
}

// [PUT]: /user/update
Future<dynamic> updateUserApi(Map<String, dynamic> data) async {
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

// [PUT]: /user/plan/upgrade
Future<dynamic> upgradePlanApi(String appUserId) async {
  final token = await getToken();
  if (token == null) throw Exception('No token found');

  final res = await http.put(
    Uri.parse('$api/plan/upgrade'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'appUserId': appUserId,
      'platform': Platform.isIOS ? 'ios' : 'android',
    }),
  );

  if (res.statusCode >= 400) {
    final body = jsonDecode(res.body);
    throw Exception(body['message'] ?? 'Unknown error');
  }

  return jsonDecode(res.body);
}
