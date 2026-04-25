import 'package:flutter/material.dart';

class WheelSlider extends StatelessWidget {
  final int itemCount;
  final int initialIndex;
  final ValueChanged<int> onSelectedItemChanged;
  final double itemExtent;
  final Widget Function(BuildContext, int) itemBuilder;
  final FixedExtentScrollController? controller;

  const WheelSlider({
    super.key,
    required this.itemCount,
    this.initialIndex = 0,
    required this.onSelectedItemChanged,
    this.itemExtent = 40, //height of the item
    required this.itemBuilder,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            height: itemExtent,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).secondaryHeaderColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        ListWheelScrollView.useDelegate(
          itemExtent: itemExtent,
          perspective: 0.005,
          diameterRatio: 1.2,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: onSelectedItemChanged,
          controller:
              controller ??
              FixedExtentScrollController(initialItem: initialIndex),

          childDelegate: ListWheelChildLoopingListDelegate(
            children: List.generate(
              itemCount,
              (index) => itemBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }
}
