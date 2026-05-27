import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../models/weather_model.dart';
import 'weather_states.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit({AppLocalizations? l10n})
      : _l10n = l10n,
        super(WeatherInitial()) {
    _loadLastCity();
  }

  final _dio = Dio();
  final AppLocalizations? _l10n;
  String? lastCity;

  Future<void> _loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    lastCity = prefs.getString(AppConstants.keyLastCity);
    if (lastCity != null && lastCity!.isNotEmpty) {
      getWeather(city: lastCity!);
    }
  }

  Future<void> getWeather({required String city}) async {
    if (city.trim().isEmpty) return;
    emit(WeatherLoading());
    try {
      final response = await _dio.get(
        '${AppConstants.weatherBaseUrl}/forecast.json',
        queryParameters: {
          'key':    AppConstants.weatherApiKey,
          'q':      city.trim(),
          'days':   3,
          'aqi':    'no',
          'alerts': 'no',
        },
      );

      final forecasts = List.generate(
        3,
        (i) => WeatherModel.fromJson(
            Map<String, dynamic>.from(response.data as Map), i),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyLastCity, city.trim());
      lastCity = city.trim();

      emit(WeatherSuccess(forecasts, city.trim()));
    } on DioException catch (e) {
      final serverMsg =
          e.response?.data?['error']?['message'] as String?;
      final fallback = _l10n?.cityNotFound ??
          'City not found. Please check the name.';
      emit(WeatherFailure(serverMsg ?? fallback));
    } catch (_) {
      final fallback = _l10n?.errNoNetwork ??
          'Could not load weather. Check your connection.';
      emit(WeatherFailure(fallback));
    }
  }

  void reset() => emit(WeatherInitial());
}
