import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWrapper(
        children: [
          const Text(
            'Forgot Password Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          // Reset password button
          ElevatedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/reset-password'),
            child: const Text('Reset Password'),
          ),

          // Back to sign in button
          ElevatedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/sign-in'),
            child: const Text('Back to Sign In'),
          ),
        ],
      ),
    );
  }
}
