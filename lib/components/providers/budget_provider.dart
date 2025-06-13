import 'package:advanced_mobile_app/models/budget_model.dart';
import 'package:flutter/material.dart';

class BudgetProvider extends ChangeNotifier {
  List<Budget> _budgets = [];
  bool _loading = false;

  List<Budget> get budgets => _budgets;
  bool get loading => _loading;

  void setBudgets(List<Budget> budgets) {
    _budgets = budgets;
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
