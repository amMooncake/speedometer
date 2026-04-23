import 'package:flutter/material.dart';

/// view model for changing theme
class ThemeViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  /// get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// check if current theme is dark
  bool get isDark => _themeMode == ThemeMode.dark;

  /// toggle theme
  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
