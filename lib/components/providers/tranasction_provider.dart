import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _loading = false;

  List<Transaction> get transactions => _transactions;
  bool get loading => _loading;

  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
