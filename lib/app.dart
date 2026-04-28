import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:speedometer_mobile/config/theme.dart';
import 'package:speedometer_mobile/config/theme2.dart';
import 'package:speedometer_mobile/viewmodels/theme/theme_model.dart';
import 'package:speedometer_mobile/views/home_screen.dart';

class AppColors {
  static const primary = Colors.orange;
}

class Speedometer extends StatelessWidget {
  const Speedometer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeViewModel.themeMode,
      theme: AppTheme.lightColorScheme,
      darkTheme: AppTheme.darkColorScheme,
      // home: const OnboardingScreen(),
      home: const HomeScreen(),
    );
    // different style
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   themeMode: themeViewModel.themeMode,
    //   theme: ThemeData(
    //     useMaterial3: true,
    //     colorScheme: lightColorScheme,
    //     fontFamily: '.SF Pro Text',
    //   ),
    //   darkTheme: ThemeData(
    //     useMaterial3: true,
    //     colorScheme: darkColorScheme,
    //     fontFamily: '.SF Pro Text',
    //   ),
    //   // home: const OnboardingScreen(),
    //   home: const HomeScreen(),
    // );
  }
}
