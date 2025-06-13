import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String baseUrl = (kDebugMode && !kIsWeb)
    ? 'http://192.168.2.11:3000'
    : dotenv.env['WEB_SERVER_URL']!;

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

// Admob ID Types
enum AdmobType { appOpen, banner, interstitial, native }

final Map<AdmobType, Map<String, String>> admobIds = {
  AdmobType.appOpen: {
    'dev': '', // hoặc test ID của admob
    'ios': dotenv.env['ADMOB_IOS_APPOPEN_ID']!,
    'android': dotenv.env['ADMOB_ANDROID_APPOPEN_ID']!,
  },
  AdmobType.banner: {
    'dev': '',
    'ios': dotenv.env['ADMOB_IOS_BANNER_ID']!,
    'android': dotenv.env['ADMOB_ANDROID_BANNER_ID']!,
  },
  AdmobType.interstitial: {
    'dev': '',
    'ios': dotenv.env['ADMOB_IOS_INTERSTITIAL_ID']!,
    'android': dotenv.env['ADMOB_ANDROID_INTERSTITIAL_ID']!,
  },
  AdmobType.native: {
    'dev': '',
    'ios': dotenv.env['ADMOB_IOS_NATIVE_ID']!,
    'android': dotenv.env['ADMOB_ANDROID_NATIVE_ID']!,
  },
};

String getAdmobId(AdmobType type) {
  if (kDebugMode) return admobIds[type]!['dev']!;
  if (Platform.isIOS) return admobIds[type]!['ios']!;
  if (Platform.isAndroid) return admobIds[type]!['android']!;
  return admobIds[type]!['dev']!;
}
