import 'package:flutter/material.dart';
import '../../../../core/helper/extensions/media_query.dart';

/// Renders a two-tone rich-text header.
/// [title] is the primary bold line; [subtitle] the muted secondary line.
class TitleHeaderWidget extends StatelessWidget {
  const TitleHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary   = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: context.sp(22),
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        SizedBox(height: context.h(4)),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: context.sp(13),
            color: onSurface.withOpacity(0.65),
          ),
        ),
      ],
    );
  }
}
