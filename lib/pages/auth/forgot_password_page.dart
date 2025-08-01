import 'package:advanced_mobile_app/components/input.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailCtl = TextEditingController();
  Map<String, String> formErrors = {};
  bool loading = false;

  bool validateForm() {
    setState(() => formErrors = {});

    bool isValid = true;
    final email = emailCtl.text.trim();

    if (email.isEmpty) {
      formErrors['email'] = 'Email is required';
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,8}$').hasMatch(email)) {
      formErrors['email'] = 'Invalid email';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  Future<void> handleForgotPassword() async {
    if (!validateForm()) return;

    setState(() => loading = true);

    try {
      final response = await forgotPasswordApi({'email': emailCtl.text});
      final message = response['message'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );

      Navigator.pushReplacementNamed(context, '/sign-in');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send reset link'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Background
        Positioned.fill(
          child: Image.asset(
            isDark ? 'assets/images/block-2.png' : 'assets/images/block-1.png',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          text: 'AMA',
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

                  // Forgot Password Form
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 32,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Reset Your Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your email to receive a password reset link',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 24),

                        Input(
                          labelText: 'Email',
                          controller: emailCtl,
                          errorText: formErrors['email'],
                        ),
                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: loading ? null : handleForgotPassword,
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
                                  'Send Reset Link',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Remember your password?',
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
