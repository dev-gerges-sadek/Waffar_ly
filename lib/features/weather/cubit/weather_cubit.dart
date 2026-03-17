import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../models/weather_model.dart';
import 'weather_states.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial()) {
    _loadLastCity();
  }

  final _dio = Dio();
  String? lastCity;

  // ── Load last searched city on startup ────────────────────────────────────
  Future<void> _loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    lastCity = prefs.getString(AppConstants.keyLastCity);
    if (lastCity != null && lastCity!.isNotEmpty) {
      getWeather(city: lastCity!);
    }
  }

  // ── Fetch 3-day forecast ──────────────────────────────────────────────────
  Future<void> getWeather({required String city}) async {
    if (city.trim().isEmpty) return;
    emit(WeatherLoading());
    try {
      final response = await _dio.get(
        '${AppConstants.weatherBaseUrl}/forecast.json',
        queryParameters: {
          'key':   AppConstants.weatherApiKey,
          'q':     city.trim(),
          'days':  3,
          'aqi':   'no',
          'alerts':'no',
        },
      );

      final forecasts = List.generate(
        3,
        (i) => WeatherModel.fromJson(
            Map<String, dynamic>.from(response.data), i),
      );

      // Save to prefs for next app open
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyLastCity, city.trim());
      lastCity = city.trim();

      emit(WeatherSuccess(forecasts, city.trim()));
    } on DioException catch (e) {
      final msg = e.response?.data?['error']?['message'] as String?
          ?? 'City not found. Please check the name.';
      emit(WeatherFailure(msg));
    } catch (e) {
      emit(WeatherFailure('Could not load weather. Check your connection.'));
    }
  }

  void reset() => emit(WeatherInitial());
}
