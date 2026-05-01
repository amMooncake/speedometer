import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedometer_mobile/res/app_dimens.dart';
import 'package:speedometer_mobile/viewmodels/theme/theme_model.dart';
import 'package:speedometer_mobile/views/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:speedometer_mobile/blocs/authentication_bloc/authentication_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final themeViewModel = context.watch<ThemeViewModel>();
    final user = context.read<AuthenticationBloc>().state.user;

    String userName = 'Użytkownik';
    if (user != null) {
      if (user.name.isNotEmpty) {
        userName = user.name;
      } else if (user.email.isNotEmpty) {
        userName = user.email;
      }
    }

    return Padding(
      padding: AppDimens.paddingAll(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Cześć, $userName!',
                  style: t.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppDimens.gap(4),
                SwitchListTile(
                  title: const Text('Zgodnie z systemem'),
                  secondary: const Icon(Icons.sync),
                  value: themeViewModel.themeMode == ThemeMode.system,
                  onChanged: (bool value) {
                    if (value) {
                      themeViewModel.setThemeMode(ThemeMode.system);
                    } else {
                      final brightness = MediaQuery.of(context).platformBrightness;
                      themeViewModel.setThemeMode(
                        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
                      );
                    }
                  },
                ),
                if (themeViewModel.themeMode != ThemeMode.system)
                  SwitchListTile(
                    title: themeViewModel.themeMode == ThemeMode.dark
                        ? const Text('Tryb ciemny')
                        : const Text('Tryb jasny'),
                    secondary: Icon(
                      themeViewModel.themeMode == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                    value: themeViewModel.themeMode == ThemeMode.dark,
                    onChanged: (bool value) {
                      themeViewModel.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),
                const Divider(),
                ListTile(
                  title: const Text('Wyloguj', style: TextStyle(color: Colors.red)),
                  leading: const Icon(Icons.logout, color: Colors.red),
                  onTap: () {
                    context.read<SignInBloc>().add(SignOutRequired());
                  },
                ),
                const Divider(),
              ],
            ),
          ),
          Image.asset("assets/logo.png", height: 100),
          AppDimens.gap(2),
          _buildCredits(t),
        ],
      ),
    );
  }
}

Widget _buildCredits(ThemeData t) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: t.textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.5, fontSize: 12),
      children: [
        TextSpan(
          text:
              'Aplikacja stworzona przez Aleksego Malawskiego \n i Igora Nejmana dla WSEI Kraków z ',
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Icon(Icons.favorite, size: 16, color: Colors.redAccent),
        ),
        TextSpan(
          text: ' oraz ',
        ),
        WidgetSpan(alignment: PlaceholderAlignment.middle, child: FlutterLogo(size: 16)),
      ],
    ),
  );
}
