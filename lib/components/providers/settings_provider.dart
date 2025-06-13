import 'package:advanced_mobile_app/models/settings_model.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  Settings? _settings;
  bool _loading = false;

  Settings? get settings => _settings;
  bool get loading => _loading;

  void setSettings(Settings? settings) {
    _settings = settings;
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
