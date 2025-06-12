import 'package:advanced_mobile_app/pages/auth/forgot_password_page.dart';
import 'package:advanced_mobile_app/pages/auth/sign_in_page.dart';
import 'package:advanced_mobile_app/pages/auth/sign_up_page.dart';
import 'package:advanced_mobile_app/pages/home/_home_layout.dart';
import 'package:advanced_mobile_app/pages/home/calendar_page.dart';
import 'package:advanced_mobile_app/pages/home/premium_page.dart';
import 'package:advanced_mobile_app/pages/home/streaks_page.dart';
import 'package:advanced_mobile_app/pages/welcome/onboarding_page.dart';
import 'package:advanced_mobile_app/pages/welcome/welcome_page.dart';
import 'package:advanced_mobile_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMA',

      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const WelcomePage(),
      routes: {
        '/home': (context) => HomeLayout(initialPageIndex: 0),
        '/transactions': (context) => const HomeLayout(initialPageIndex: 1),
        '/ai': (context) => const HomeLayout(initialPageIndex: 2),
        '/budgets': (context) => const HomeLayout(initialPageIndex: 3),
        '/account': (context) => const HomeLayout(initialPageIndex: 4),
        '/calendar': (context) => const CalendarPage(),
        '/streaks': (context) => const StreaksPage(),
        '/premium': (context) => const PremiumPage(),

        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),

        '/welcome': (context) => const WelcomePage(),
        '/onboarding': (context) => const OnboardingPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
