import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// view model for changing theme
class ThemeViewModel extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode;

  ThemeViewModel({ThemeMode? initialMode}) : _themeMode = initialMode ?? ThemeMode.system;

  /// get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// check if current theme is dark
  bool get isDark => _themeMode == ThemeMode.dark;

  /// set theme explicitly
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _themeMode.index);
  }

  /// toggle theme (legacy support if needed)
  Future<void> toggleTheme() async {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _themeMode.index);
  }

  /// static method to load initial theme
  static Future<ThemeMode> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themeKey);
    if (index != null && index < ThemeMode.values.length) {
      return ThemeMode.values[index];
    }
    return ThemeMode.system;
  }
}
