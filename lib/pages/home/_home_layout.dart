import 'package:advanced_mobile_app/components/header.dart';
import 'package:advanced_mobile_app/components/navbar.dart';
import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:advanced_mobile_app/pages/home/account_page.dart';
import 'package:advanced_mobile_app/pages/home/ai_page.dart';
import 'package:advanced_mobile_app/pages/home/budgets_page.dart';
import 'package:advanced_mobile_app/pages/home/home_page.dart';
import 'package:advanced_mobile_app/pages/home/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeLayout extends StatefulWidget {
  final int? initialPageIndex;

  const HomeLayout({super.key, this.initialPageIndex});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int selectedPageIndex = 0;
  final List<Widget> pages = [
    HomePage(),
    TransactionsPage(),
    AIPage(),
    BudgetsPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    selectedPageIndex = widget.initialPageIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final onboarding = authProvider.onboarding;

    if (user == null) {
      if (onboarding != null) {
        // Use WidgetsBinding to navigate after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/sign-in');
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      } else {
        // Use WidgetsBinding to navigate after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/welcome');
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    }

    return Scaffold(
      appBar: Header(),
      body: pages[selectedPageIndex],
      bottomNavigationBar: Navbar(
        selectedPageIndex: selectedPageIndex,
        onChangePage: (int index) => setState(() => selectedPageIndex = index),
      ),
    );
  }
}
