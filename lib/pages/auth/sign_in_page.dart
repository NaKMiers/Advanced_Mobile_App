import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWrapper(
        children: [
          const Text(
            'Sign In Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          // sign up button
          ElevatedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/sign-up'),
            child: const Text('Sign Up'),
          ),

          // forgot password button
          ElevatedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/forgot-password'),
            child: const Text('Forgot Password'),
          ),
        ],
      ),
    );
  }
}
