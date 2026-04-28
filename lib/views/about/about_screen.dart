import 'package:flutter/material.dart';
import 'package:speedometer_mobile/res/dimens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: AppDimens.paddingAll(4),
      child: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          Image.asset("assets/logo.png"),
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
