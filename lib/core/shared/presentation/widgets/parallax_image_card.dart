import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:waffar_ly_app/core/theme/sh_colors.dart';

class ParallaxImageCard extends StatelessWidget {
  const ParallaxImageCard({
    super.key,
    required this.imageUrl,
    this.parallaxValue = 0,
  });

  final String imageUrl;
  final double parallaxValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Parallax image
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: SHColors.lightHintColor,
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(-7, 7)),
            ],
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(Colors.black26, BlendMode.colorBurn),
              alignment: Alignment(lerpDouble(.5, -.5, parallaxValue)!, 0),
            ),
          ),
        ),
        // Vignette overlay
       const DecoratedBox(
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.all(Radius.circular(12)),
            gradient:  RadialGradient(
              radius: 2,
              colors: [Colors.transparent, Colors.black],
            ),
          ),
        ),
      ],
    );
  }
}
