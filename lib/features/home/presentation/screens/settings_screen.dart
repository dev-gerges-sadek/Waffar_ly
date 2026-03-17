// ignore_for_file: deprecated_member_use
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/app/app_routes.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/locale_cubit.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/shared/presentation/widgets/sh_app_bar.dart';
import '../../../../core/shared/presentation/widgets/sh_card.dart';
import '../../../../core/theme/sh_colors.dart';
import '../../../auth/cubit/cubit.dart';
import '../../../auth/cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is SignOutState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.signin, (route) => false);
        }
      },
      child: Scaffold(
        appBar: const ShAppBar(showSettings: false),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settings,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: SHColors.text(context),
                ),
              ),
              SizedBox(height: 24.h),

              // ── Appearance ───────────────────────────────────────────
              _SectionLabel(l10n.appearance.toUpperCase()),
              SizedBox(height: 12.h),
              SHCard(
                childrenPadding: EdgeInsets.all(12.w),
                children: [
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      final isDark = Theme.of(context).brightness ==
                          Brightness.dark;
                      final activeColor = isDark
                          ? SHColors.darkPrimaryColor
                          : SHColors.lightPrimaryColor;
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(l10n.darkMode,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: SHColors.text(context))),
                                SizedBox(height: 4.h),
                                Text(
                                  themeProvider.isDarkMode
                                      ? l10n.darkEnabled
                                      : l10n.lightEnabled,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: SHColors.hint(context)),
                                ),
                              ],
                            ),
                          ),
                          CupertinoSwitch(
                            value: themeProvider.isDarkMode,
                            onChanged: (_) => themeProvider.toggleTheme(),
                            activeTrackColor: activeColor,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // ── Language ─────────────────────────────────────────────
              _SectionLabel(l10n.language.toUpperCase()),
              SizedBox(height: 12.h),
              SHCard(
                childrenPadding: EdgeInsets.all(12.w),
                children: [
                  BlocBuilder<LocaleCubit, Locale>(
                    builder: (context, locale) {
                      final isAr  = locale.languageCode == 'ar';
                      final prim  = SHColors.primary(context);
                      return Column(children: [
                        _LangOption(
                          label:    l10n.english,
                          flag:     '🇬🇧',
                          selected: !isAr,
                          primary:  prim,
                          onTap: () =>
                              context.read<LocaleCubit>().setLocale('en'),
                        ),
                        SizedBox(height: 8.h),
                        _LangOption(
                          label:    l10n.arabic,
                          flag:     '🇪🇬',
                          selected: isAr,
                          primary:  prim,
                          onTap: () =>
                              context.read<LocaleCubit>().setLocale('ar'),
                        ),
                      ]);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // ── About ────────────────────────────────────────────────
              _SectionLabel(l10n.about.toUpperCase()),
              SizedBox(height: 12.h),
              SHCard(
                childrenPadding: EdgeInsets.all(12.w),
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l10n.appVersion,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: SHColors.text(context))),
                    SizedBox(height: 4.h),
                    Text('1.0.0',
                        style: TextStyle(
                            fontSize: 12.sp, color: SHColors.hint(context))),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l10n.application,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: SHColors.text(context))),
                    SizedBox(height: 4.h),
                    Text(l10n.appName,
                        style: TextStyle(
                            fontSize: 12.sp, color: SHColors.hint(context))),
                  ]),
                ],
              ),
              SizedBox(height: 20.h),

              // ── Account ──────────────────────────────────────────────
              _SectionLabel(l10n.account.toUpperCase()),
              SizedBox(height: 12.h),
              SHCard(
                childrenPadding: EdgeInsets.all(12.w),
                children: [
                  BlocBuilder<AuthCubit, AuthStates>(
                    builder: (context, state) {
                      final isLoading = state is LoginLoadingState;
                      return GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => context.read<AuthCubit>().signOut(),
                        child: Row(children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(Icons.logout_rounded,
                                color: Colors.red, size: 20.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.signOut,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red)),
                                Text(l10n.signOutSub,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: SHColors.hint(context))),
                              ],
                            ),
                          ),
                          if (isLoading)
                            SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red),
                            )
                          else
                            Icon(Icons.arrow_forward_ios_rounded,
                                size: 14.sp, color: Colors.red),
                        ]),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: SHColors.hint(context),
            letterSpacing: 0.8));
  }
}

// ─── Language option ──────────────────────────────────────────────────────────
class _LangOption extends StatelessWidget {
  const _LangOption({
    required this.label,
    required this.flag,
    required this.selected,
    required this.primary,
    required this.onTap,
  });
  final String label, flag;
  final bool   selected;
  final Color  primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? primary.withOpacity(0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
              color: selected
                  ? primary.withOpacity(0.40)
                  : Colors.transparent),
        ),
        child: Row(children: [
          Text(flag, style: TextStyle(fontSize: 20.sp)),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? primary : SHColors.text(context))),
          ),
          if (selected)
            Icon(Icons.check_circle_rounded,
                color: primary, size: 18.sp),
        ]),
      ),
    );
  }
}
