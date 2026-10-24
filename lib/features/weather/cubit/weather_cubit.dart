import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/l10n/app_localizations.dart';
import '../data/weather_repository.dart';
import 'weather_states.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._repo, {AppLocalizations? l10n})
    : _l10n = l10n,
      super(WeatherInitial()) {
    _loadLastCity();
  }

  final WeatherRepository _repo;
  final AppLocalizations? _l10n;
  String? lastCity;

  Future<void> _loadLastCity() async {
    final city = await _repo.loadLastCity();
    if (isClosed) return;
    lastCity = city;
    if (city != null && city.isNotEmpty) unawaited(getWeather(city: city));
  }

  Future<void> getWeather({required String city}) async {
    final q = city.trim();
    if (q.isEmpty || q.length > 80) return;
    emit(WeatherLoading());
    try {
      final forecasts = await _repo.fetchForecast(q);
      await _repo.saveLastCity(q);
      lastCity = q;
      if (!isClosed) emit(WeatherSuccess(forecasts, q));
    } on CityNotFoundException {
      if (!isClosed) {
        emit(WeatherFailure(
          _l10n?.cityNotFound ?? 'City not found. Please check the name.',
        ));
      }
    } on DioException catch (e) {
      // 400 from WeatherAPI = unknown location; anything else = connectivity.
      final notFound = e.response?.statusCode == 400;
      final fallback = notFound
          ? (_l10n?.cityNotFound ?? 'City not found. Please check the name.')
          : (_l10n?.errNoNetwork ?? 'No internet connection.');
      if (!isClosed) emit(WeatherFailure(fallback));
    } catch (_) {
      if (!isClosed) {
        emit(
          WeatherFailure(
            _l10n?.errNoNetwork ?? 'Could not load weather. Check your connection.',
          ),
        );
      }
    }
  }

  void reset() => emit(WeatherInitial());
}
