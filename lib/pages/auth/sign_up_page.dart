import 'dart:convert';

import 'package:advanced_mobile_app/components/input.dart';
import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:advanced_mobile_app/models/user_model.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameCtl = TextEditingController();
  final TextEditingController emailCtl = TextEditingController();
  final TextEditingController passwordCtl = TextEditingController();

  bool loading = false;
  String locale = 'en';
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  Map<String, String> formErrors = {};

  // Validation logic
  bool validateForm() {
    setState(() {
      formErrors = {};
    });

    bool isValid = true;

    if (usernameCtl.text.trim().isEmpty) {
      setState(() {
        formErrors['username'] = 'Username is required';
      });
      isValid = false;
    } else if (usernameCtl.text.length < 5) {
      setState(() {
        formErrors['username'] = 'Username must be at least 5 characters';
      });
      isValid = false;
    }

    if (emailCtl.text.trim().isEmpty) {
      setState(() {
        formErrors['email'] = 'Email is required';
      });
      isValid = false;
    } else if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,8}$',
    ).hasMatch(emailCtl.text)) {
      setState(() {
        formErrors['email'] = 'Invalid email';
      });
      isValid = false;
    }

    if (passwordCtl.text.trim().isEmpty) {
      setState(() {
        formErrors['password'] = 'Password is required';
      });
      isValid = false;
    } else if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$',
    ).hasMatch(passwordCtl.text)) {
      setState(() {
        formErrors['password'] =
            'Password must be at least 6 characters and contain at least 1 lowercase, 1 uppercase, 1 number';
      });
      isValid = false;
    }

    return isValid;
  }

  // Handle credential sign-up
  Future<void> handleCredentialSignUp() async {
    if (!validateForm()) return;

    setState(() {
      loading = true;
    });

    try {
      final data = {
        'username': usernameCtl.text,
        'email': emailCtl.text,
        'password': passwordCtl.text,
      };

      final response = await registerCredentialsApi(data, locale);
      final token = response['token'];
      final decodedUser = JwtDecoder.decode(token);
      final user = User.fromJson(decodedUser);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      final currency = await prefs.getString('currency');
      final personalities = await prefs.getString('personalities');
      if (currency != null || personalities != null) {
        final settingsData = {
          'currency': currency != null ? jsonDecode(currency) : 'USD',
          'personalities': personalities != null
              ? jsonDecode(personalities)
              : [0],
        };
        await updateMySettingsApi(settingsData);
      }

      // Update AuthProvider
      Provider.of<AuthProvider>(context, listen: false).setUser(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign Up Success'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up Failed'), backgroundColor: Colors.red),
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
                    SizedBox(
                      height: MediaQuery.of(context).padding.top + 20,
                    ), // Adjust for SafeArea
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

                    // Sign-up form container
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
                            'Sign Up to Deewas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Welcome! Please fill in the details to get started',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),

                          const SizedBox(height: 24),

                          // MARK: Google Sign-In Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/google.png',
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text('Sign In with Facebook'),
                              ],
                            ),
                            onPressed: () {},
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

                          // MARK: Form
                          Input(labelText: 'Username', controller: usernameCtl),
                          const SizedBox(height: 24),
                          Input(labelText: 'Email', controller: emailCtl),
                          const SizedBox(height: 24),
                          Input(
                            labelText: 'Password',
                            controller: passwordCtl,
                            isPassword: true,
                          ),

                          const SizedBox(height: 24),

                          // MARK: Sign Up Button
                          ElevatedButton(
                            onPressed: loading ? null : handleCredentialSignUp,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Theme.of(context).primaryColor,
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
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 24),

                          // MARK: Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/sign-in',
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20), // Bottom padding
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
