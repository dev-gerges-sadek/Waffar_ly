import 'package:flutter/material.dart';
import '../../../theme/sh_colors.dart';

/// Small pulsing dot used to indicate a "live" state.
/// Colour sourced from [SHColors.primary] — no hardcoded hex.
class BlueLightDot extends StatelessWidget {
  const BlueLightDot({super.key});

  @override
  Widget build(BuildContext context) {
    final color = SHColors.primary(context);
    return SizedBox.square(
      dimension: 8,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color, blurRadius: 10)],
        ),
      ),
    );
  }
}
