abstract class AppConstants {
  // ── Firebase collections ──────────────────────────────────────────────────
  static const String colDeviceStates   = 'device_states';
  static const String colDeviceStatesHw = 'device_states_hw';
  static const String colDeviceCommands = 'device_commands';
  static const String colUsers          = 'users';
  static const String colDeviceHistory  = 'device_history';
  static const String colAnomalyAlerts  = 'device_alerts';
  static const String colEnergyDaily    = 'energy_daily';

  // ── SharedPreferences keys ────────────────────────────────────────────────
  static const String keyDarkMode        = 'is_dark_mode';
  static const String keySeenOnboarding  = 'seen_onboarding';
  static const String keyLastCity        = 'last_weather_city';
  static const String keyAppLocale       = 'app_locale';
  static const String keyElectricityRate = 'electricity_rate_per_kwh';

  // ── Weather API (weatherapi.com) ──────────────────────────────────────────
  static const String weatherApiKey  = 'c9ff61e482ca4f27984155623241010';
  static const String weatherBaseUrl = 'https://api.weatherapi.com/v1';

  // ── Anthropic API (Chatbot) ───────────────────────────────────────────────
  // ضع الـ API key هنا أو في .env file
  static const String anthropicApiKey = 'YOUR_ANTHROPIC_API_KEY';
  static const String anthropicModel  = 'claude-sonnet-4-20250514';

  // ── Anomaly Detection ─────────────────────────────────────────────────────
  static const double anomalyZScoreThreshold = 2.5;
  static const int anomalyMinDataPoints = 5;

  // ── Design ────────────────────────────────────────────────────────────────
  static const Duration animDuration    = Duration(milliseconds: 300);
  static const Duration fastAnim        = Duration(milliseconds: 150);
}
