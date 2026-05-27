// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:waffar_ly_app/core/theme/sh_colors.dart';

class LightedBackground extends StatelessWidget {
  const LightedBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // ✅ ألوان تتغير مع الـ theme
    final primaryColor = SHColors.primary(context);
    final secondaryColor = Theme.of(context).brightness == Brightness.dark
        ? SHColors.darkSecondaryColor
        : SHColors.lightSecondaryColor;
    final accentColor = Theme.of(context).brightness == Brightness.dark
        ? SHColors.darkAccentColor
        : SHColors.lightAccentColor;
    final bgColor = SHColors.background(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // Scale decorative blobs relative to screen size (avoids overlap on small phones).
        final blob1 = (w * 0.45).clamp(220.0, 340.0);
        final blob2 = (w * 0.40).clamp(200.0, 320.0);
        final blob3 = (w * 0.28).clamp(160.0, 240.0);

        final offset1 = blob1 * 0.30;
        final offset2 = blob2 * 0.25;
        final top3 = (h * 0.22).clamp(120.0, 260.0);
        final left3 = (w * 0.08).clamp(20.0, 80.0);

        return Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: bgColor),
            Positioned(
              top: -offset1,
              right: -offset1,
              child: Container(
                width: blob1,
                height: blob1,
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
              bottom: -offset2,
              left: -offset2,
              child: Container(
                width: blob2,
                height: blob2,
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
              top: top3,
              left: left3,
              child: Container(
                width: blob3,
                height: blob3,
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
      },
    );
  }
}
