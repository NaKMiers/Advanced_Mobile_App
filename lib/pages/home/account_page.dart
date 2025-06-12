import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      children: [
        const Text(
          'Account Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        // sign button
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/sign-in'),
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
