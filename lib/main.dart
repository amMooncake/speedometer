import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedometer_mobile/app.dart';
import 'package:speedometer_mobile/viewmodels/theme/theme_model.dart';

void main() {
  // here providers will be set, if neaded
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: const Speedometer(),
    ),
  );
}
