import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/firebase_options.dart';
import 'core/app/auth_session_guard.dart';
import 'core/di/injection.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_cubit.dart';
import 'core/router/router.dart';
import 'core/theme/sh_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/cubit/cubit.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Never write diagnostics to the device log in release builds.
  if (!kDebugMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupDependencies();

  // Restore persisted settings first -> correct language/theme on frame 1.
  final localeCubit = await LocaleCubit.restore();
  final themeCubit = await ThemeCubit.restore();

  runApp(WaffarApp(localeCubit: localeCubit, themeCubit: themeCubit));
}

class WaffarApp extends StatelessWidget {
  const WaffarApp({
    super.key,
    required this.localeCubit,
    required this.themeCubit,
  });

  final LocaleCubit localeCubit;
  final ThemeCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider.value(value: localeCubit),
        BlocProvider.value(value: themeCubit),
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
                    onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appName,
                    theme: SHTheme.light,
                    darkTheme: SHTheme.dark,
                    themeMode: themeMode,
                    locale: locale,
                    navigatorKey: _navigatorKey,
                    // RTL is derived from the locale by the localization
                    // delegates; only the session guard is added here.
                    builder: (ctx, child) => AuthSessionGuard(
                      navigatorKey: _navigatorKey,
                      child: child ?? const SizedBox.shrink(),
                    ),
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
