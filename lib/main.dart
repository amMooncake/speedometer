import 'package:flutter/material.dart';
import 'package:speedometer_mobile/app.dart';
import 'package:speedometer_mobile/viewmodels/theme/theme_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_repository/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize();
  final initialTheme = await ThemeViewModel.loadTheme();

  runApp(
    Speedometer(
      userRepository: FirebaseUserRepo(),
      initialTheme: initialTheme,
    ),
  );
}
