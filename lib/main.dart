import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:advanced_mobile_app/components/providers/budget_provider.dart';
import 'package:advanced_mobile_app/components/providers/category_provider.dart';
import 'package:advanced_mobile_app/components/providers/init_provider.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/components/providers/tranasction_provider.dart';
import 'package:advanced_mobile_app/components/providers/wallet_provider.dart';
import 'package:advanced_mobile_app/models/budget_model.dart';
import 'package:advanced_mobile_app/models/category_model.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/models/wallet_model.dart';
import 'package:advanced_mobile_app/pages/auth/_auth_layout.dart';
import 'package:advanced_mobile_app/pages/drawers/create_budget.dart';
import 'package:advanced_mobile_app/pages/drawers/create_category.dart';
import 'package:advanced_mobile_app/pages/drawers/create_transaction.dart';
import 'package:advanced_mobile_app/pages/drawers/create_wallet.dart';
import 'package:advanced_mobile_app/pages/drawers/update_budget.dart';
import 'package:advanced_mobile_app/pages/drawers/update_category.dart';
import 'package:advanced_mobile_app/pages/drawers/update_transaction.dart';
import 'package:advanced_mobile_app/pages/drawers/update_wallet.dart';
import 'package:advanced_mobile_app/pages/home/_home_layout.dart';
import 'package:advanced_mobile_app/pages/home/calendar_page.dart';
import 'package:advanced_mobile_app/pages/home/categories_page.dart';
import 'package:advanced_mobile_app/pages/home/premium_page.dart';
import 'package:advanced_mobile_app/pages/home/streaks_page.dart';
import 'package:advanced_mobile_app/pages/home/wallets_page.dart';
import 'package:advanced_mobile_app/pages/welcome/onboarding_page.dart';
import 'package:advanced_mobile_app/pages/welcome/welcome_page.dart';
import 'package:advanced_mobile_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('en');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LoadProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),

        ChangeNotifierProvider(
          create: (context) => InitProvider(context),
          lazy: false,
        ),
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
        '/wallets': (context) => const WalletsPage(),
        '/categories': (context) => const CategoriesPage(),
        '/calendar': (context) => const CalendarPage(),
        '/streaks': (context) => const StreaksPage(),
        '/premium': (context) => const PremiumPage(),

        '/sign-in': (context) => const AuthLayout(initialPageIndex: 0),
        '/sign-up': (context) => const AuthLayout(initialPageIndex: 1),
        '/forgot-password': (context) => const AuthLayout(initialPageIndex: 2),

        '/welcome': (context) => const WelcomePage(),
        '/onboarding': (context) => const OnboardingPage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // WALLETS
          case '/create-wallet':
            return MaterialPageRoute(builder: (_) => const CreateWalletPage());
          case '/update-wallet':
            Wallet wallet = settings.arguments as Wallet;
            return MaterialPageRoute(
              builder: (_) => UpdateWalletPage(wallet: wallet),
            );

          // CATEGORIES
          case '/create-category':
            String? type = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (_) => CreateCategoryPage(type: type),
            );
          case '/update-category':
            Category category = settings.arguments as Category;
            return MaterialPageRoute(
              builder: (_) => UpdateCategoryPage(category: category),
            );

          // BUDGETS
          case '/create-budget':
            final args = settings.arguments as Map<String, dynamic>?;
            DateTime? begin = args?['begin'] as DateTime?;
            DateTime? end = args?['end'] as DateTime?;
            return MaterialPageRoute(
              builder: (_) => CreateBudgetPage(begin: begin, end: end),
            );
          case '/update-budget':
            Budget budget = settings.arguments as Budget;
            return MaterialPageRoute(
              builder: (_) => UpdateBudgetPage(budget: budget),
            );

          // TRANSACTIONS
          case '/create-transaction':
            final args = settings.arguments as Map<String, dynamic>?;
            Wallet? wallet = args?['wallet'] as Wallet?;
            Category? category = args?['category'] as Category?;
            String? type = args?['type'] as String?;
            return MaterialPageRoute(
              builder: (_) => CreateTransactionPage(
                wallet: wallet,
                category: category,
                type: type,
              ),
            );
          case '/update-transaction':
            Transaction transaction = settings.arguments as Transaction;
            return MaterialPageRoute(
              builder: (_) => UpdateTransactionPage(transaction: transaction),
            );

          default:
            return null;
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
