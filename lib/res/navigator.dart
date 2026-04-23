import 'package:flutter/material.dart';

/// A helper class for navigation operations in the application,
// ignore: prefer_match_file_name
class NavigatorHelper {
  NavigatorHelper._(); // Private constructor to prevent instantiation.

  // ignore: public_member_api_docs, member_ordering, avoid_global_state
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigates to a new screen.
  static Future<void>? to(Widget path) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => path));
    }

    return null;
  }

  /// Pops all screens until reaching the first screen.
  static void popAll() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  /// Replaces the current screen with a new screen.
  static void replace(Widget path) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => path));
    }
  }

  /// Pops the current screen.
  static void pop([dynamic data]) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).pop(data);
    }
  }
}
