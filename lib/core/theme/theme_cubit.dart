import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Pure Cubit theme controller (the old ThemeProvider has been removed).
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit([super.initialState = ThemeMode.light]);

  /// Reads the saved theme BEFORE runApp so there is no light->dark flash.
  static Future<ThemeCubit> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(AppConstants.keyDarkMode) ?? false;
    return ThemeCubit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  bool get isDark => state == ThemeMode.dark;

  Future<void> toggleTheme() => setDarkMode(!isDark);

  Future<void> setDarkMode(bool value) async {
    final next = value ? ThemeMode.dark : ThemeMode.light;
    if (state == next) return;
    emit(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyDarkMode, value);
  }
}
