import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedometer_mobile/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:speedometer_mobile/config/theme2.dart';
import 'package:speedometer_mobile/viewmodels/theme/theme_model.dart';
import 'package:speedometer_mobile/views/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:speedometer_mobile/views/auth/views/welcome_screen.dart';
import 'package:speedometer_mobile/views/home_screen.dart';
import 'package:user_repository/user_repository.dart';

class MyAppView extends StatelessWidget {
  final UserRepository userRepository;

  const MyAppView({required this.userRepository, super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeViewModel.themeMode,
      theme: AppTheme.lightColorScheme,
      darkTheme: AppTheme.darkColorScheme,
      // home: const OnboardingScreen(),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return BlocProvider(
              create: (context) => SignInBloc(context.read<AuthenticationBloc>().userRepository),
              child: const HomeScreen(),
            );
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
