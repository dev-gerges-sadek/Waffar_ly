// ignore_for_file: deprecated_member_use
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/locale_cubit.dart';
import '../../../../core/router/router.dart';
import '../../../../core/shared/presentation/widgets/sh_app_bar.dart';
import '../../../../core/shared/presentation/widgets/sh_card.dart';
import '../../../../core/theme/sh_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../auth/cubit/cubit.dart';
import '../../../auth/cubit/states.dart';
import '../widgets/settings_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is SignOutState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRouter.signin, (route) => false);
        }
      },
      child: Scaffold(
        appBar: const ShAppBar(showSettings: false),
        body: SingleChildScrollView(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 20.h),
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

              // ── Appearance ────────────────────────────────────────
              SettingsSectionLabel(l10n.appearance.toUpperCase()),
              SizedBox(height: 12.h),
              SHCard(
                childrenPadding: EdgeInsets.all(12.w),
                children: [
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      final isDark    = themeMode == ThemeMode.dark;
                      final activeColor = isDark
                          ? SHColors.darkPrimaryColor
                          : SHColors.lightPrimaryColor;
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.darkMode,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: SHColors.text(context),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  isDark ? l10n.darkEnabled : l10n.lightEnabled,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: SHColors.hint(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CupertinoSwitch(
                            value: isDark,
                            onChanged: (_) =>
                                context.read<ThemeCubit>().toggleTheme(),
                            activeTrackColor: activeColor,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // ── Language ──────────────────────────────────────────
              SettingsSectionLabel(l10n.language.toUpperCase()),
              SizedBox(height: 12.h),
              SHCard(
                childrenPadding: EdgeInsets.all(12.w),
                children: [
                  BlocBuilder<LocaleCubit, Locale>(
                    builder: (context, locale) {
                      final isAr  = locale.languageCode == 'ar';
                      final prim  = SHColors.primary(context);
                      return Column(
                        children: [
                          LanguageOption(
                            label: l10n.english,
                            flag: '🇬🇧',
                            selected: !isAr,
                            primaryColor: prim,
                            onTap: () =>
                                context.read<LocaleCubit>().setLocale('en'),
                          ),
                          SizedBox(height: 8.h),
                          LanguageOption(
                            label: l10n.arabic,
                            flag: '🇪🇬',
                            selected: isAr,
                            primaryColor: prim,
                            onTap: () =>
                                context.read<LocaleCubit>().setLocale('ar'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // ── About ─────────────────────────────────────────────
              SettingsSectionLabel(l10n.about.toUpperCase()),
              SizedBox(height: 12.h),
              SHCard(
                childrenPadding: EdgeInsets.all(12.w),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.appVersion,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: SHColors.text(context))),
                      SizedBox(height: 4.h),
                      Text('1.0.0',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: SHColors.hint(context))),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.application,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: SHColors.text(context))),
                      SizedBox(height: 4.h),
                      Text(l10n.appName,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: SHColors.hint(context))),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // ── Account ───────────────────────────────────────────
              SettingsSectionLabel(l10n.account.toUpperCase()),
              SizedBox(height: 12.h),
              SHCard(
                childrenPadding: EdgeInsets.all(12.w),
                children: [
                  BlocBuilder<AuthCubit, AuthStates>(
                    builder: (context, state) {
                      final isLoading = state is LoginLoadingState;
                      final isRtl     = Directionality.of(context) ==
                          TextDirection.rtl;
                      return GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => context.read<AuthCubit>().signOut(),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: SHColors.error(context).withOpacity(0.10),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(Icons.logout_rounded,
                                  color: SHColors.error(context), size: 20.sp),
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
                                          color: SHColors.error(context))),
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
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: SHColors.error(context)),
                              )
                            else
                              Icon(
                                isRtl
                                    ? Icons.arrow_back_ios_rounded
                                    : Icons.arrow_forward_ios_rounded,
                                size: 14.sp,
                                color: SHColors.error(context),
                              ),
                          ],
                        ),
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
