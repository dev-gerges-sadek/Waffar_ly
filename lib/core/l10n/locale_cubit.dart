import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code  = prefs.getString(AppConstants.keyAppLocale) ?? 'en';
    emit(Locale(code));
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyAppLocale, languageCode);
    emit(Locale(languageCode));
  }

  void toggleLocale() {
    setLocale(state.languageCode == 'en' ? 'ar' : 'en');
  }

  bool get isArabic => state.languageCode == 'ar';
}
