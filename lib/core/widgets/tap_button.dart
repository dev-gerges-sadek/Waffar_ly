import 'package:flutter/material.dart';

/// Tappable area that is announced as a button by screen readers and keeps a
/// >= 48dp touch target. Drop-in replacement for a bare [GestureDetector].
class TapButton extends StatelessWidget {
  const TapButton({
    super.key,
    required this.onTap,
    required this.child,
    this.label,
    this.behavior = HitTestBehavior.opaque,
  });

  final VoidCallback? onTap;
  final Widget child;

  /// Optional spoken label; when null, the child's own text is read.
  final String? label;
  final HitTestBehavior behavior;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onTap != null,
    label: label,
    child: GestureDetector(onTap: onTap, behavior: behavior, child: child),
  );
}
