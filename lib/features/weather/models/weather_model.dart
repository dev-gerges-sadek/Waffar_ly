/// Locale-independent advice code; text comes from the ARB files.
enum AcAdvice { veryHot, warm, cold }

class WeatherModel {
  final String cityName;
  final String country;
  final String date;
  final double avgTemp;
  final double minTemp;
  final double maxTemp;
  final String condition;
  final String iconUrl;
  final double humidity;
  final double windKph;
  final double feelsLike;
  final bool isDay;

  const WeatherModel({
    required this.cityName,
    required this.country,
    required this.date,
    required this.avgTemp,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
    required this.iconUrl,
    required this.humidity,
    required this.windKph,
    required this.feelsLike,
    required this.isDay,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, int dayIndex) {
    Map<String, dynamic> m(Object? v) => Map<String, dynamic>.from(v as Map);
    final forecastDay =
        m(((m(json['forecast'])['forecastday']) as List)[dayIndex]);
    final day       = m(forecastDay['day']);
    final condition = m(day['condition']);
    final current   = m(json['current']);
    final loc       = m(json['location']);
    double n(Object? v) => (v as num).toDouble();
    return WeatherModel(
      cityName:  loc['name']    as String,
      country:   loc['country'] as String,
      date:      forecastDay['date'] as String,
      avgTemp:   n(day['avgtemp_c']),
      minTemp:   n(day['mintemp_c']),
      maxTemp:   n(day['maxtemp_c']),
      condition: condition['text'] as String,
      iconUrl:   'https:${condition['icon']}',
      humidity:  n(day['avghumidity']),
      windKph:   n(day['maxwind_kph']),
      feelsLike: dayIndex == 0 ? n(current['feelslike_c']) : n(day['avgtemp_c']),
      isDay:     dayIndex == 0 ? (current['is_day'] as num) == 1 : true,
    );
  }

  /// Suggest AC temperature based on outdoor weather
  /// Returns null if no recommendation needed
  AcAdvice? get acRecommendation {
    if (avgTemp >= 35) return AcAdvice.veryHot;
    if (avgTemp >= 28) return AcAdvice.warm;
    if (avgTemp <= 10) return AcAdvice.cold;
    return null;
  }

  bool get isHot  => avgTemp >= 28;
  bool get isCold => avgTemp <= 15;
}
