import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedometer_mobile/res/dimens.dart';
import 'package:speedometer_mobile/viewmodels/theme/theme_model.dart';
import 'package:speedometer_mobile/views/auth/blocs/sign_in_bloc/sign_in_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final themeViewModel = context.watch<ThemeViewModel>();
    return Padding(
      padding: AppDimens.paddingAll(4),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Tryb ciemny'),
                  secondary: Icon(
                    themeViewModel.isDark ? Icons.dark_mode : Icons.light_mode,
                  ),
                  value: themeViewModel.isDark,
                  onChanged: (bool value) {
                    themeViewModel.toggleTheme();
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
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'App made by Aleksy Malawski & Igor Nejman',
        style: t.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        textAlign: TextAlign.center,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'for WSEI with',
            style: t.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.favorite,
            size: 16,
            color: Colors.redAccent,
          ),
          const SizedBox(width: 6),
          Text(
            'and',
            style: t.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(width: 6),
          const FlutterLogo(size: 16),
        ],
      ),
    ],
  );
}
