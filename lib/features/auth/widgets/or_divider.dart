// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waffar_ly_app/core/helper/extensions/media_query.dart';
import '../cubit/cubit.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final surface   = Theme.of(context).colorScheme.surface;

    return Column(
      children: [
        SizedBox(height: context.h(16)),
        Row(
          children: [
            // Divider line
            Expanded(
              child: Divider(color: onSurface.withOpacity(0.2), thickness: 1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(12)),
              child: Text(
                'Or sign $text with',
                style: TextStyle(
                  fontSize: context.sp(14),
                  color: onSurface.withOpacity(0.6), // ✅ theme-aware
                ),
              ),
            ),
            Expanded(
              child: Divider(color: onSurface.withOpacity(0.2), thickness: 1),
            ),
          ],
        ),
        SizedBox(height: context.h(16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Apple button
            _SocialButton(
              bgColor: surface,
              borderColor: onSurface.withOpacity(0.2),
              child: Icon(Icons.apple, color: onSurface, size: 24),
              onTap: () {},
            ),
            SizedBox(width: context.w(16)),
            // Google button
            _SocialButton(
              bgColor: surface,
              borderColor: onSurface.withOpacity(0.2),
              child: Container(
                width: context.w(24),
                height: context.w(24),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_image.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () => context.read<AuthCubit>().signInWithGoogle(),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.bgColor,
    required this.borderColor,
    required this.child,
    required this.onTap,
  });

  final Color bgColor;
  final Color borderColor;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
