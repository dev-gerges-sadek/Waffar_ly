import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit([super.initialState = const Locale('en')]);

  /// Reads the saved locale BEFORE runApp so the first frame is correct.
  static Future<LocaleCubit> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(AppConstants.keyAppLocale);
    final supported = code == 'ar' || code == 'en';
    return LocaleCubit(Locale(supported ? code! : 'en'));
  }

  Future<void> setLocale(String languageCode) async {
    if (languageCode != 'en' && languageCode != 'ar') return;
    emit(Locale(languageCode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyAppLocale, languageCode);
  }

  void toggleLocale() {
    setLocale(state.languageCode == 'en' ? 'ar' : 'en');
  }

  bool get isArabic => state.languageCode == 'ar';
}
