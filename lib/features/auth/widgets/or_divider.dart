import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/extensions/media_query.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/cubit.dart';

class OrDivider extends StatelessWidget {
  /// [mode] is 'in' (sign-in) or 'up' (sign-up) — drives l10n label.
  const OrDivider({super.key, required this.mode});
  final String mode; // 'in' | 'up'

  @override
  Widget build(BuildContext context) {
    final l10n     = AppLocalizations.of(context);
    final onSurf   = Theme.of(context).colorScheme.onSurface;
    final surface  = Theme.of(context).colorScheme.surface;
    final divLabel = mode == 'in' ? l10n.signIn : l10n.signUp;

    return Column(
      children: [
        SizedBox(height: context.h(16)),
        Row(
          children: [
            Expanded(child: Divider(color: onSurf.withOpacity(0.2), thickness: 1)),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: context.w(12)),
              child: Text(
                '${l10n.language == 'العربية' ? 'أو تسجيل' : 'Or'} $divLabel ${l10n.language == 'العربية' ? 'بواسطة' : 'with'}',
                style: TextStyle(
                  fontSize: context.sp(13),
                  color: onSurf.withOpacity(0.6),
                ),
              ),
            ),
            Expanded(child: Divider(color: onSurf.withOpacity(0.2), thickness: 1)),
          ],
        ),
        SizedBox(height: context.h(16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialBtn(
              bgColor: surface,
              borderColor: onSurf.withOpacity(0.2),
              onTap: () {},
              child: Icon(Icons.apple, color: onSurf, size: 24),
            ),
            SizedBox(width: context.w(16)),
            _SocialBtn(
              bgColor: surface,
              borderColor: onSurf.withOpacity(0.2),
              onTap: () => context.read<AuthCubit>().signInWithGoogle(),
              child: SizedBox(
                width: context.w(24),
                height: context.w(24),
                child: const Image(
                  image: AssetImage('assets/images/google_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  const _SocialBtn({
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
  Widget build(BuildContext context) => GestureDetector(
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
