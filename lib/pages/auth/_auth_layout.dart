import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:advanced_mobile_app/pages/auth/forgot_password_page.dart';
import 'package:advanced_mobile_app/pages/auth/sign_in_page.dart';
import 'package:advanced_mobile_app/pages/auth/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthLayout extends StatefulWidget {
  final int? initialPageIndex;

  const AuthLayout({super.key, this.initialPageIndex});

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {
  int selectedPageIndex = 0;
  final List<Widget> pages = [SignInPage(), SignUpPage(), ForgotPasswordPage()];

  @override
  void initState() {
    super.initState();
    selectedPageIndex = widget.initialPageIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user != null) {
      // Use WidgetsBinding to navigate after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/home');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(body: pages[selectedPageIndex]);
  }
}
