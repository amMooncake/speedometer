import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedometer_mobile/app_view.dart';
import 'package:speedometer_mobile/viewmodels/theme/theme_model.dart';
import 'package:user_repository/user_repository.dart';
import 'package:speedometer_mobile/viewmodels/calculator/calculation_history_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedometer_mobile/blocs/authentication_bloc/authentication_bloc.dart';

class Speedometer extends StatelessWidget {
  final UserRepository userRepository;
  final ThemeMode initialTheme;

  const Speedometer({
    required this.userRepository,
    required this.initialTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel(initialMode: initialTheme)),
        ChangeNotifierProvider(create: (_) => CalculationHistoryViewModel()),
        BlocProvider(create: (_) => AuthenticationBloc(userRepository: userRepository)),
      ],
      child: MyAppView(userRepository: userRepository),
    );
  }
}
