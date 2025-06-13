import 'package:advanced_mobile_app/models/wallet_model.dart';
import 'package:flutter/material.dart';

class WalletProvider extends ChangeNotifier {
  List<Wallet> _wallets = [];
  Wallet? _defaultWallet;
  bool _loading = false;

  List<Wallet> get wallets => _wallets;
  Wallet? get defaultWallet => _defaultWallet;
  bool get loading => _loading;

  void setWallets(List<Wallet> wallets) {
    _wallets = wallets;
    notifyListeners();
  }

  void setDefaultWallet(Wallet? wallet) {
    _defaultWallet = wallet;
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
