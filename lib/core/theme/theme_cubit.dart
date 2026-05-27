import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Replaces ThemeProvider (ChangeNotifier) — pure Cubit, no Provider dependency.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(AppConstants.keyDarkMode) ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  bool get isDark => state == ThemeMode.dark;

  Future<void> toggleTheme() async {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyDarkMode, next == ThemeMode.dark);
  }

  Future<void> setDarkMode(bool value) async {
    final next = value ? ThemeMode.dark : ThemeMode.light;
    if (state == next) return;
    emit(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyDarkMode, value);
  }
}
