import 'dart:convert';

import 'package:advanced_mobile_app/utils/utils.dart';
import 'package:http/http.dart' as http;

String api = '$baseUrl/api/auth';

// [POST]: /auth/sign-in/credentials
Future<Map<String, dynamic>> signInCredentialsApi(
  Map<String, dynamic> data,
) async {
  final res = await http.post(
    Uri.parse('$api/sign-in/credentials'),
    body: jsonEncode(data),
    headers: {'Content-Type': 'application/json'},
  );

  if (res.statusCode < 200 || res.statusCode >= 300) {
    throw jsonDecode(res.body);
  }
  return jsonDecode(res.body);
}

// [POST]: /auth/sign-up/credentials
Future<Map<String, dynamic>> registerCredentialsApi(
  Map<String, dynamic> data,
  String locale,
) async {
  final res = await http.post(
    Uri.parse('$api/sign-up/credentials'),
    body: jsonEncode({...data, 'locale': locale}),
    headers: {'Content-Type': 'application/json'},
  );

  if (res.statusCode < 200 || res.statusCode >= 300) {
    throw jsonDecode(res.body);
  }
  return jsonDecode(res.body);
}

// [POST]: /auth/sign-in/google
Future<Map<String, dynamic>> signInGoogleApi(
  String idToken,
  String googleUserId,
  String locale,
) async {
  final res = await http.post(
    Uri.parse('$api/sign-in/google'),
    body: jsonEncode({
      'idToken': idToken,
      'googleUserId': googleUserId,
      'locale': locale,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (res.statusCode < 200 || res.statusCode >= 300) {
    throw jsonDecode(res.body);
  }
  return jsonDecode(res.body);
}

// [POST]: /auth/sign-in/apple
Future<Map<String, dynamic>> signInAppleApi(
  String idToken,
  String appleUserId,
  String nonce,
  String locale,
) async {
  final res = await http.post(
    Uri.parse('$api/sign-in/apple'),
    body: jsonEncode({
      'idToken': idToken,
      'appleUserId': appleUserId,
      'nonce': nonce,
      'locale': locale,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (res.statusCode < 200 || res.statusCode >= 300) {
    throw jsonDecode(res.body);
  }
  return jsonDecode(res.body);
}

// [POST]: /auth/forgot-password
Future<Map<String, dynamic>> forgotPasswordApi(
  Map<String, dynamic> data,
) async {
  final res = await http.post(
    Uri.parse('$api/forgot-password'),
    body: jsonEncode(data),
    headers: {'Content-Type': 'application/json'},
  );

  if (res.statusCode < 200 || res.statusCode >= 300) {
    throw jsonDecode(res.body);
  }
  return jsonDecode(res.body);
}

// [PATCH]: /auth/reset-password
Future<Map<String, dynamic>> resetPasswordApi(
  String token,
  String newPassword,
) async {
  final res = await http.patch(
    Uri.parse('$api/reset-password?token=$token'),
    body: jsonEncode({'newPassword': newPassword}),
    headers: {'Content-Type': 'application/json'},
  );

  if (res.statusCode < 200 || res.statusCode >= 300) {
    throw jsonDecode(res.body);
  }
  return jsonDecode(res.body);
}
