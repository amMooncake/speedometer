import 'package:flutter/material.dart';
import 'package:speedometer_mobile/res/dimens.dart';

class WheelSlider extends StatelessWidget {
  final int itemCount;
  final int initialIndex;
  final ValueChanged<int> onSelectedItemChanged;
  final double itemExtent;
  final Widget Function(BuildContext, int) itemBuilder;
  final FixedExtentScrollController? controller;
  final Axis scrollDirection;

  const WheelSlider({
    super.key,
    required this.itemCount,
    this.initialIndex = 0,
    required this.onSelectedItemChanged,
    this.itemExtent = 40,
    required this.itemBuilder,
    this.controller,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isHorizontal = scrollDirection == Axis.horizontal;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Selection highlight
        Container(
          width: AppDimens.baseSize * 8,
          height: AppDimens.baseSize * 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [0, 0.4, 0.6, 1],
              colors: [
                t.colorScheme.primary.withAlpha(0),
                t.colorScheme.primary.withAlpha(100),
                t.colorScheme.primary.withAlpha(100),
                t.colorScheme.primary.withAlpha(0),
              ],
            ),
          ),
        ),
        // The Wheel
        RotatedBox(
          quarterTurns: isHorizontal ? -1 : 0,
          child: ListWheelScrollView.useDelegate(
            itemExtent: itemExtent,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onSelectedItemChanged,
            controller: controller ?? FixedExtentScrollController(initialItem: initialIndex),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) => RotatedBox(
                quarterTurns: isHorizontal ? 1 : 0,
                child: itemBuilder(context, index),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
