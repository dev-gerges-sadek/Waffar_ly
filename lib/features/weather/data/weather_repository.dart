import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../models/weather_model.dart';

/// Network + persistence for weather. Keeps Dio / SharedPreferences out of
/// the cubit so it can be unit-tested with a fake.
/// Thrown when the weather provider does not know the requested city.
class CityNotFoundException implements Exception {
  const CityNotFoundException();
}

class WeatherRepository {
  WeatherRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  final Dio _dio;

  Future<String?> loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyLastCity);
  }

  Future<void> saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyLastCity, city);
  }

  /// 3-day forecast for [city]. Throws [DioException] on failure.
  Future<List<WeatherModel>> fetchForecast(String city) async {
    if (AppConstants.useBackendProxy) return _viaBackend(city);
    final response = await _dio.get(
      '${AppConstants.weatherBaseUrl}/forecast.json',
      queryParameters: {
        'key': AppConstants.weatherApiKey,
        'q': city,
        'days': 3,
        'aqi': 'no',
        'alerts': 'no',
      },
    );
    final json = Map<String, dynamic>.from(response.data as Map);
    return List.generate(3, (i) => WeatherModel.fromJson(json, i));
  }

  Future<List<WeatherModel>> _viaBackend(String city) async {
    try {
      final res = await FirebaseFunctions.instanceFor(region: AppConstants.functionsRegion)
          .httpsCallable('weatherForecast')
          .call<Map<Object?, Object?>>({'city': city})
          .timeout(const Duration(seconds: 15));
      final json = Map<String, dynamic>.from(res.data['forecast'] as Map);
      return List.generate(3, (i) => WeatherModel.fromJson(json, i));
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'not-found') throw const CityNotFoundException();
      rethrow;
    }
  }
}
