import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access AuthProvider to check logout state
    final authProvider = Provider.of<AuthProvider>(context);

    return PageWrapper(
      children: [
        const Text(
          'Account Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: authProvider.isLoggingOut
              ? null
              : () async {
                  try {
                    await authProvider.logout();
                    // Navigator.pushReplacementNamed(context, '/auth/sign-in');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Logout failed: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: authProvider.isLoggingOut
              ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
              : const Text('Sign Out'),
        ),
      ],
    );
  }
}
