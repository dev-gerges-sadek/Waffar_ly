// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../theme/sh_icons.dart';

class ShimmerArrows extends StatefulWidget {
  const ShimmerArrows({super.key});

  @override
  State<ShimmerArrows> createState() => _ShimmerArrowsState();
}

class _ShimmerArrowsState extends State<ShimmerArrows>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Gradient get gradient {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.white : Colors.black;

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        baseColor.withOpacity(0.1),
        baseColor,
        baseColor.withOpacity(0.1)
      ],
      stops: const [0.0, 0.3, 1],
      transform: _SlideGradientTransform(_controller.value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return ShaderMask(
          shaderCallback: (bounds) => gradient.createShader(bounds),
          child: child,
        );
      },
      child: const Column(
        children: [
          Align(heightFactor: .4, child: Icon(SHIcons.arrowUp)),
          Align(heightFactor: .4, child: Icon(SHIcons.arrowUp)),
          Align(heightFactor: .4, child: Icon(SHIcons.arrowUp)),
        ],
      ),
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  const _SlideGradientTransform(this.percent);

  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(0, -(bounds.height * percent), 0);
}
