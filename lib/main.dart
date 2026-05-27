import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/firebase_options.dart';
import 'core/di/injection.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_cubit.dart';
import 'core/router/router.dart';
import 'core/theme/sh_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/cubit/cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupDependencies();
  runApp(const WaffarApp());
}

class WaffarApp extends StatelessWidget {
  const WaffarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (_, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (_, locale) {
              return ScreenUtilInit(
                designSize: const Size(390, 844),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (ctx, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Waffar',
                    theme: SHTheme.light,
                    darkTheme: SHTheme.dark,
                    themeMode: themeMode,
                    locale: locale,
                    // Ensure RTL layout when Arabic is selected
                    builder: (ctx, child) {
                      return Directionality(
                        textDirection: locale.languageCode == 'ar'
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: child!,
                      );
                    },
                    supportedLocales: AppLocalizations.supportedLocales,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    initialRoute: AppRouter.splash,
                    onGenerateRoute: AppRouter.onGenerateRoute,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
