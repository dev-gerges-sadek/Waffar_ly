import 'package:flutter/material.dart';
import '../theme/sh_colors.dart';

/// Helpers للكود اللي بيستخدم AppColors — كلها بتاخد context عشان تدعم Dark Mode.
class AppColors {
  static Color primaryBlue(BuildContext context) => SHColors.primary(context);
  static Color secondaryBlue(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? SHColors.darkSecondaryColor
          : SHColors.lightSecondaryColor;
  static Color greyText(BuildContext context) => SHColors.hint(context);
  static Color redColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? SHColors.darkErrorColor
          : SHColors.lightErrorColor;
  static Color backgroundColor(BuildContext context) => SHColors.background(context);

  // ✅ بدل ما يكونوا hardcoded، بيتبعوا الـ theme
  static Color get whiteColor => Colors.white;
  static Color get blackColor => Colors.black;
}
