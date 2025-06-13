import 'dart:convert';

import 'package:advanced_mobile_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isPremium = false;
  bool _isLoading = false;
  Map<String, dynamic>? _onboarding;
  bool _isLoggingOut = false;

  User? get user => _user;
  bool get isPremium => _isPremium;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get onboarding => _onboarding;
  bool get isLoggingOut => _isLoggingOut;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserData();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final onboardingJson = prefs.getString('onboarding');

      if (token != null) {
        final decodedUser = JwtDecoder.decode(token);
        final user = User.fromJson(decodedUser);
        final isExpired =
            DateTime.now().millisecondsSinceEpoch >= user.exp * 1000;

        if (!isExpired) {
          _user = user;
          if (onboardingJson != null) {
            _onboarding = jsonDecode(onboardingJson);
          }
          _updatePremiumStatus();
        } else {
          await refreshToken();
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      await _clearStorage();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update premium status based on user plan
  void _updatePremiumStatus() {
    if (_user == null || _user!.plan == null) {
      _isPremium = false;
      return;
    }

    switch (_user!.plan) {
      case 'premium-lifetime':
        _isPremium = true;
        break;
      case 'premium-monthly':
      case 'premium-yearly':
        _isPremium =
            _user!.planExpiredAt != null &&
            _user!.planExpiredAt!.isAfter(DateTime.now());
        break;
      default:
        _isPremium = false;
    }
    notifyListeners();
  }

  // Refresh token (replace with your actual API call)
  Future<void> refreshToken() async {
    if (_user == null) return;

    try {
      // Simulated API call
      final response = await Future.delayed(Duration(seconds: 1), () {
        return {'token': 'new_sample_jwt_token'};
      });
      final newToken = response['token'];
      if (newToken == null) {
        throw Exception('Token is null');
      }
      final decodedUser = JwtDecoder.decode(newToken);
      _user = User.fromJson(decodedUser);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', newToken);
      _updatePremiumStatus();
      notifyListeners();
    } catch (e) {
      print('Error refreshing token: $e');
    }
  }

  // Handle logout
  Future<void> logout() async {
    _isLoggingOut = true;
    notifyListeners();

    await _clearStorage();
    _user = null;
    _isPremium = false;
    _onboarding = null;
    _isLoggingOut = false;
    notifyListeners();
  }

  // Clear storage
  Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('messages');
  }

  // Set user and onboarding data
  void setUser(User user, {Map<String, dynamic>? onboarding}) async {
    _user = user;
    if (onboarding != null) {
      _onboarding = onboarding;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding', jsonEncode(onboarding));
    }
    _updatePremiumStatus();
    notifyListeners();
  }

  // Auto logout if user is deleted
  void checkUserStatus(BuildContext context) {
    if (_user != null && _user!.isDeleted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Account Deleted'),
          content: Text(
            'Your account has been deleted. Please create a new account to continue using the app.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await logout();
                Navigator.of(context).pushReplacementNamed('/auth/sign-in');
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      );
    }
  }
}
