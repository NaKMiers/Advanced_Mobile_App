import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:advanced_mobile_app/pages/auth/_auth_layout.dart';
import 'package:advanced_mobile_app/pages/home/_home_layout.dart';
import 'package:advanced_mobile_app/pages/home/calendar_page.dart';
import 'package:advanced_mobile_app/pages/home/premium_page.dart';
import 'package:advanced_mobile_app/pages/home/streaks_page.dart';
import 'package:advanced_mobile_app/pages/welcome/onboarding_page.dart';
import 'package:advanced_mobile_app/pages/welcome/welcome_page.dart';
import 'package:advanced_mobile_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensure bindings
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const AuthLayout(initialPageIndex: 0),
      routes: {
        '/home': (context) => HomeLayout(initialPageIndex: 0),
        '/transactions': (context) => const HomeLayout(initialPageIndex: 1),
        '/ai': (context) => const HomeLayout(initialPageIndex: 2),
        '/budgets': (context) => const HomeLayout(initialPageIndex: 3),
        '/account': (context) => const HomeLayout(initialPageIndex: 4),
        '/calendar': (context) => const CalendarPage(),
        '/streaks': (context) => const StreaksPage(),
        '/premium': (context) => const PremiumPage(),

        '/sign-in': (context) => const AuthLayout(initialPageIndex: 0),
        '/sign-up': (context) => const AuthLayout(initialPageIndex: 1),
        '/forgot-password': (context) => const AuthLayout(initialPageIndex: 2),

        '/welcome': (context) => const WelcomePage(),
        '/onboarding': (context) => const OnboardingPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
