import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedometer_mobile/models/calculation_result.dart';

class CalculationHistoryViewModel extends ChangeNotifier {
  static const String _storageKey = 'calculation_history';
  List<CalculationResult> _history = [];

  List<CalculationResult> get history => List.unmodifiable(_history.reversed);

  CalculationHistoryViewModel() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historyJson = prefs.getString(_storageKey);

      if (historyJson != null) {
        final List<dynamic> decoded = jsonDecode(historyJson);
        _history = decoded.map((item) => CalculationResult.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  Future<void> addResult({
    required double distanceMeters,
    required double timeSeconds,
    required double paceSecondsPerKm,
  }) async {
    final result = CalculationResult(
      distanceMeters: distanceMeters,
      timeSeconds: timeSeconds,
      paceSecondsPerKm: paceSecondsPerKm,
    );

    _history.add(result);
    notifyListeners();
    await _saveHistory();
  }

  Future<void> clearHistory() async {
    _history.clear();
    notifyListeners();
    await _saveHistory();
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(_history.map((e) => e.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }
}
