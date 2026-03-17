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
    final day     = json['forecast']['forecastday'][dayIndex]['day'];
    final current = json['current'];
    final loc     = json['location'];
    return WeatherModel(
      cityName:  loc['name']    as String,
      country:   loc['country'] as String,
      date:      json['forecast']['forecastday'][dayIndex]['date'] as String,
      avgTemp:   (day['avgtemp_c']  as num).toDouble(),
      minTemp:   (day['mintemp_c']  as num).toDouble(),
      maxTemp:   (day['maxtemp_c']  as num).toDouble(),
      condition: day['condition']['text'] as String,
      iconUrl:   'https:${day['condition']['icon']}',
      humidity:  (day['avghumidity']  as num).toDouble(),
      windKph:   (day['maxwind_kph']  as num).toDouble(),
      feelsLike: dayIndex == 0
          ? (current['feelslike_c'] as num).toDouble()
          : (day['avgtemp_c']       as num).toDouble(),
      isDay:     dayIndex == 0 ? (current['is_day'] as int) == 1 : true,
    );
  }

  /// Suggest AC temperature based on outdoor weather
  /// Returns null if no recommendation needed
  String? get acRecommendation {
    if (avgTemp >= 35) return 'It\'s very hot outside. Recommend AC at 22°C.';
    if (avgTemp >= 28) return 'Warm outside. Recommend AC at 24°C.';
    if (avgTemp <= 10) return 'Cold outside. Consider heating to 22°C.';
    return null;
  }

  bool get isHot  => avgTemp >= 28;
  bool get isCold => avgTemp <= 15;
}
