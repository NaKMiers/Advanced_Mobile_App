import 'package:advanced_mobile_app/models/wallet_model.dart' as app_models;
import 'package:advanced_mobile_app/models/category_model.dart' as app_models;
import 'package:advanced_mobile_app/models/budget_model.dart' as app_models;
import 'package:advanced_mobile_app/models/settings_model.dart' as app_models;
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
import 'budget_provider.dart';
import 'category_provider.dart';
import 'load_provider.dart';
import 'settings_provider.dart';
import 'wallet_provider.dart';

class InitProvider extends ChangeNotifier {
  final BuildContext context;

  InitProvider(this.context) {
    context.read<AuthProvider>().addListener(_onUserChanged);
  }

  Future<void> _init() async {
    print('🔄 InitProvider: starting _init');

    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;
    print('🔄 InitProvider: starting _init2');

    final walletProvider = context.read<WalletProvider>();
    final categoryProvider = context.read<CategoryProvider>();
    final budgetProvider = context.read<BudgetProvider>();
    final settingsProvider = context.read<SettingsProvider>();

    // Start loading
    walletProvider.setLoading(true);
    categoryProvider.setLoading(true);
    budgetProvider.setLoading(true);
    settingsProvider.setLoading(true);

    try {
      final result = await initApi();
      List<app_models.Wallet> wallets = result['wallets'] != null
          ? (result['wallets'] as List)
                .map((json) => app_models.Wallet.fromJson(json))
                .toList()
          : [];
      walletProvider.setWallets(wallets);
      walletProvider.setDefaultWallet(wallets.isNotEmpty ? wallets[0] : null);

      List<app_models.Category> categories = result['categories'] != null
          ? (result['categories'] as List)
                .map((json) => app_models.Category.fromJson(json))
                .toList()
          : [];
      categoryProvider.setCategories(categories);

      List<app_models.Budget> budgets = result['budgets'] != null
          ? (result['budgets'] as List)
                .map((json) => app_models.Budget.fromJson(json))
                .toList()
          : [];
      budgetProvider.setBudgets(budgets);

      app_models.Settings? settings = result['settings'] != null
          ? app_models.Settings.fromJson(result['settings'])
          : null;
      settingsProvider.setSettings(settings);
    } catch (e) {
      print('Init error: $e');
    } finally {
      // Stop loading
      walletProvider.setLoading(false);
      categoryProvider.setLoading(false);
      budgetProvider.setLoading(false);
      settingsProvider.setLoading(false);
      context.read<LoadProvider>().setRefreshing(false);
    }
  }

  Future<void> refreshInit() async {
    await _init();
  }

  Future<void> refreshSettings() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    final settingsProvider = context.read<SettingsProvider>();
    settingsProvider.setLoading(true);

    try {
      // Mock getMySettingsApi
      final settings = await getMySettingsApi();
      settingsProvider.setSettings(settings);
    } catch (e) {
      print('Settings error: $e');
    } finally {
      settingsProvider.setLoading(false);
    }
  }

  void _onUserChanged() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      _init();
    }
  }
}
