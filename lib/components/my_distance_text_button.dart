import 'package:flutter/material.dart';
import 'package:speedometer_mobile/res/app_dimens.dart';

class MyDistanceTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const MyDistanceTextButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: AppDimens.paddingSymetric(1, 0.2),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
