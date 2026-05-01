import 'package:flutter/material.dart';

/// A manager class for displaying error and success toast notifications
// ignore: prefer_match_file_name
class ToastManager {
  /// Displays an error toast notification with the given message.
  static void showErrorToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Displays a success toast notification with the given message.
  static void showSuccessToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
