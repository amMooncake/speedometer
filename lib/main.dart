import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedometer_mobile/app.dart';
import 'package:speedometer_mobile/viewmodels/theme/theme_model.dart';
import 'package:speedometer_mobile/viewmodels/calculator/calculation_history_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialTheme = await ThemeViewModel.loadTheme();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel(initialMode: initialTheme)),
        ChangeNotifierProvider(create: (_) => CalculationHistoryViewModel()),
      ],
      child: const Speedometer(),
    ),
  );
}
