import 'dart:convert';

import 'package:advanced_mobile_app/components/input.dart';
import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:advanced_mobile_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController usernameOrEmailCtl = TextEditingController();
  final TextEditingController passwordCtl = TextEditingController();
  bool loading = false;
  String locale = 'en';
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  Map<String, String> formErrors = {};

  @override
  void dispose() {
    usernameOrEmailCtl.dispose();
    passwordCtl.dispose();
    super.dispose();
  }

  // Mock JWT token for testing
  String _generateMockToken(Map<String, dynamic> payload) {
    final header = base64Url.encode(
      utf8.encode(jsonEncode({'alg': 'HS256', 'typ': 'JWT'})),
    );
    final encodedPayload = base64Url.encode(utf8.encode(jsonEncode(payload)));
    const mockSignature = 'mock_signature';
    return '$header.$encodedPayload.$mockSignature';
  }

  // Simulated API calls (replace with real APIs)
  Future<Map<String, dynamic>> signInCredentialsApi(
    Map<String, dynamic> data,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    final payload = {
      '_id': 'user${DateTime.now().millisecondsSinceEpoch}',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'username': data['usernameOrEmail'].contains('@')
          ? 'user'
          : data['usernameOrEmail'],
      'email': data['usernameOrEmail'].contains('@')
          ? data['usernameOrEmail']
          : 'user@example.com',
      'password': data['password'],
      'authType': 'email',
      'role': 'user',
      'avatar': '',
      'name': data['usernameOrEmail'],
      'isDeleted': false,
      'initiated': true,
      'plan': null,
      'planExpiredAt': null,
      'purchasedAtPlatform': null,
      'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600,
    };
    return {'token': _generateMockToken(payload)};
  }

  Future<Map<String, dynamic>> signInGoogleApi(
    String idToken,
    String userId,
    String locale,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    final payload = {
      '_id': userId,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'username': 'google_user',
      'email': 'google_user@example.com',
      'authType': 'google',
      'role': 'user',
      'avatar': '',
      'name': 'Google User',
      'isDeleted': false,
      'initiated': true,
      'plan': null,
      'planExpiredAt': null,
      'purchasedAtPlatform': null,
      'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600,
    };
    return {'token': _generateMockToken(payload)};
  }

  // Validation logic
  bool validateForm() {
    setState(() {
      formErrors = {};
    });

    bool isValid = true;

    if (usernameOrEmailCtl.text.trim().isEmpty) {
      setState(() {
        formErrors['usernameOrEmail'] = 'Username or email is required';
      });
      isValid = false;
    }

    if (passwordCtl.text.trim().isEmpty) {
      setState(() {
        formErrors['password'] = 'Password is required';
      });
      isValid = false;
    }

    return isValid;
  }

  // Handle credential sign-in
  Future<void> handleCredentialSignIn() async {
    if (!validateForm()) return;

    setState(() {
      loading = true;
    });

    try {
      final data = {
        'usernameOrEmail': usernameOrEmailCtl.text,
        'password': passwordCtl.text,
      };

      final response = await signInCredentialsApi(data);
      final token = response['token'];
      final decodedUser = JwtDecoder.decode(token);
      final user = User.fromJson(decodedUser);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Provider.of<AuthProvider>(context, listen: false).setUser(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sign In Success'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign In Failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            isDarkMode
                ? 'assets/images/block-2.png'
                : 'assets/images/block-1.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 20),
                    // Title
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                        children: [
                          const TextSpan(
                            text: 'DEEWAS',
                            style: TextStyle(fontSize: 32),
                          ),
                          TextSpan(
                            text: '.',
                            style: TextStyle(
                              color: Colors.green[500],
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 21),
                    // Sign-in form container
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 32,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign In to Deewas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Welcome back, please sign in to continue!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 24),
                          // Social Sign-In Buttons
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/icons/google.png',
                              height: 20,
                              width: 20,
                            ),
                            label: const Text('Sign In with Google'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 36),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),

                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: const Text(
                                  'or',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Form
                          Input(
                            labelText: 'Username or Email',
                            controller: usernameOrEmailCtl,
                            errorText: formErrors['usernameOrEmail'],
                            onChanged: (value) {
                              setState(() {
                                formErrors.remove('usernameOrEmail');
                              });
                            },
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 24),
                          Input(
                            labelText: 'Password',
                            controller: passwordCtl,
                            isPassword: true,
                            errorText: formErrors['password'],
                            onChanged: (value) {
                              setState(() {
                                formErrors.remove('password');
                              });
                            },
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                context,
                                '/forgot-password',
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Sign In Button
                          ElevatedButton(
                            onPressed: loading ? null : handleCredentialSignIn,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 24),
                          // Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don’t have an account?',
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/sign-up',
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
