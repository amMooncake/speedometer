// ignore_for_file: public_member_api_docs, prefer_match_file_name
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// A class that defines the dimensions used throughout the application,
class AppDimens {
  static const double baseSize = 8;

  static const double smallRadius = baseSize;
  static const double mediumRadius = baseSize * 2;
  static const double largeRadius = baseSize * 4;

  static const double navBarExpandedHeight = 150;

  // ignore: avoid_returning_widgets
  /// return gap for spacing
  static Gap gap([double x = 1.0]) => Gap(baseSize * x);

  /// return padding for spacing
  static EdgeInsetsGeometry paddingAll([double x = 1.0]) => EdgeInsets.all(baseSize * (x));

  static EdgeInsetsGeometry paddingHorizontal([double x = 1.0]) =>
      EdgeInsets.symmetric(horizontal: baseSize * (x));

  static EdgeInsetsGeometry paddingSymetric([double x = 1.0, double y = 1.0]) =>
      EdgeInsets.symmetric(horizontal: baseSize * (x), vertical: baseSize * (y));
}

/* 

this code is copied from my other project, 

One time I tried to do something smart to use dimend with .copyWith property, 
but it's too complicated and it's not worth using

I pased it here, to have a referance if neaded

*/

// /// Custom ThemeExtension to hold dimension values
// class MyDimensions extends ThemeExtension<MyDimensions> {
//   /// small radius
//   final double smallRadius;

//   /// medium radius
//   final double mediumRadius;

//   /// create Mydimentions
//   const MyDimensions({
//     required this.smallRadius,
//     required this.mediumRadius,
//   });

//   @override
//   ThemeExtension<MyDimensions> copyWith({
//     double? smallRadius,
//     double? mediumRadius,
//   }) {
//     return MyDimensions(
//       smallRadius: smallRadius ?? this.smallRadius,
//       mediumRadius: mediumRadius ?? this.mediumRadius,
//     );
//   }

//   @override
//   ThemeExtension<MyDimensions> lerp(
//     ThemeExtension<MyDimensions>? other,
//     double t,
//   ) {
//     if (other is! MyDimensions) return this;

//     return MyDimensions(
//       smallRadius: smallRadius,
//       mediumRadius: mediumRadius,
//     );
//   }
// }
