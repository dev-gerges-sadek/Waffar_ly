import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:waffar_ly_app/firebase_options.dart';
import 'core/app/app_routes.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_cubit.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/sh_theme.dart';
import 'features/auth/cubit/cubit.dart';
import 'features/auth/signin/signin_screen.dart';
import 'features/auth/signup/sign_up_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/home/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (_, themeProvider, _) {
            return BlocBuilder<LocaleCubit, Locale>(
              builder: (_, locale) {
                return ScreenUtilInit(
                  designSize: const Size(390, 844),
                  minTextAdapt: true,
                  splitScreenMode: true,
                  builder: (_, _) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Waffar',
                      theme: SHTheme.light,
                      darkTheme: SHTheme.dark,
                      themeMode: themeProvider.isDarkMode
                          ? ThemeMode.dark
                          : ThemeMode.light,
                      locale: locale,
                      supportedLocales: AppLocalizations.supportedLocales,
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      home: const SplashScreen(),
                      routes: {
                        AppRoutes.signin: (_) => const SignInScreen(),
                        AppRoutes.signup: (_) => const SignUpScreen(),
                        AppRoutes.home:   (_) => const HomeScreen(),
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
