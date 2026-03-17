// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:waffar_ly_app/core/theme/sh_colors.dart';

class LightedBackground extends StatelessWidget {
  const LightedBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // ✅ ألوان تتغير مع الـ theme
    final primaryColor   = SHColors.primary(context);
    final secondaryColor = Theme.of(context).brightness == Brightness.dark
        ? SHColors.darkSecondaryColor
        : SHColors.lightSecondaryColor;
    final accentColor = Theme.of(context).brightness == Brightness.dark
        ? SHColors.darkAccentColor
        : SHColors.lightAccentColor;
    final bgColor = SHColors.background(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: bgColor),
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primaryColor.withOpacity(0.15),
                  primaryColor.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  secondaryColor.withOpacity(0.12),
                  secondaryColor.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: 50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  accentColor.withOpacity(0.08),
                  accentColor.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
