import 'package:flutter/material.dart';

class LoadProvider extends ChangeNotifier {
  // bool _refreshing = false;
  DateTime _refreshPoint = DateTime.now();

  // bool get refreshing => _refreshing;
  DateTime get refreshPoint => _refreshPoint;

  // void setRefreshing(bool value) {
  //   _refreshing = value;
  //   notifyListeners();
  // }

  void refresh() {
    _refreshPoint = DateTime.now();
    // _refreshing = true;
    notifyListeners();
  }
}
