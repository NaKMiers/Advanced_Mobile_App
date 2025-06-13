import 'package:advanced_mobile_app/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  bool _loading = false;

  List<Category> get categories => _categories;
  bool get loading => _loading;

  void setCategories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
