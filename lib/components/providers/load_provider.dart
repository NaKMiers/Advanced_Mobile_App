import 'package:flutter/material.dart';

class LoadProvider extends ChangeNotifier {
  bool _refreshing = false;
  int _refreshPoint = 0;

  bool get refreshing => _refreshing;
  int get refreshPoint => _refreshPoint;

  void setRefreshing(bool value) {
    _refreshing = value;
    notifyListeners();
  }

  void refresh() {
    _refreshPoint++;
    _refreshing = true;
    notifyListeners();
  }
}
