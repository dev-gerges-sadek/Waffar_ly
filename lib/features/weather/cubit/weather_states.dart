import '../models/weather_model.dart';

sealed class WeatherState {}

class WeatherInitial  extends WeatherState {}
class WeatherLoading  extends WeatherState {}

class WeatherSuccess  extends WeatherState {
  WeatherSuccess(this.forecasts, this.city);
  final List<WeatherModel> forecasts;
  final String city;
}

class WeatherFailure  extends WeatherState {
  WeatherFailure(this.message);
  final String message;
}
