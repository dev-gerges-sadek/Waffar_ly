/// DEPRECATED — retained only for backward-compat with any remaining
/// `ChangeNotifierProvider<ThemeProvider>` usages.
/// Migrate all call-sites to [ThemeCubit] (core/theme/theme_cubit.dart).
@Deprecated('Use ThemeCubit instead')
library;

export '../theme/theme_cubit.dart';
