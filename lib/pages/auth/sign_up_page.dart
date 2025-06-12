import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWrapper(
        children: [
          const Text(
            'Sign Up Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          // sign in button
          ElevatedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/sign-in'),
            child: const Text('Sign In'),
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
