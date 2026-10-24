abstract class AppConstants {
  // ── Firestore collections ─────────────────────────────────────────────────
  static const String colAiResults = 'ai_results';
  static const String colDeviceStates = 'device_states';
  static const String colDeviceCommands = 'device_commands';
  static const String colDeviceControl = 'Control';
  static const String colHardwareDevices = 'Devices';
  static const String colUsers = 'users';
  static const String colDeviceHistory = 'device_history';
  static const String colAnomalyAlerts = 'device_alerts';
  static const String colEnergyDaily = 'energy_daily';

  // ── Firestore documents ───────────────────────────────────────────────────
  static const String docSimulator = 'simulator';
  static const String docHardware = 'hardware';
  static const String docRealDevice = 'Real_Device_01';

  // ── SharedPreferences ─────────────────────────────────────────────────────
  static const String keyDarkMode = 'is_dark_mode';
  static const String keySeenOnboarding = 'seen_onboarding';
  static const String keyLastCity = 'last_weather_city';
  static const String keyAppLocale = 'app_locale';
  static const String keyElectricityRate = 'electricity_rate_per_kwh';

  // ── Weather API ───────────────────────────────────────────────────────────
  // Injected at build time:  --dart-define=WEATHER_API_KEY=xxxx
  // (or --dart-define-from-file=env.json). NEVER commit real keys.
  // NOTE: anything compiled into the app can be extracted from the binary —
  // for production, route these calls through a backend / Cloud Function.
  static const String weatherApiKey = String.fromEnvironment('WEATHER_API_KEY');
  static const String weatherBaseUrl = 'https://api.weatherapi.com/v1';

  // ── Groq API (https://console.groq.com) ───────────────────────────────────
  // Injected at build time:  --dart-define=GROQ_API_KEY=xxxx
  static const String groqApiKey = String.fromEnvironment('GROQ_API_KEY');
  static const String groqModel = 'llama-3.3-70b-versatile';

  // ── Data layout ───────────────────────────────────────────────────────────
  // false (default): classic global collections - works with the existing
  //                  ESP32 / AI service without any migration.
  // true:            per-household paths homes/{uid}/... (see README).
  //   --dart-define=HOME_SCOPED=true
  static const bool useHomeScope = bool.fromEnvironment('HOME_SCOPED');

  // ── Backend proxy ─────────────────────────────────────────────────────────
  // When true, Groq + WeatherAPI are called through the Cloud Functions in
  // /functions (API keys never ship inside the app).
  //   --dart-define=USE_BACKEND_PROXY=true
  static const String functionsRegion = 'europe-west1';
  static const bool useBackendProxy = bool.fromEnvironment('USE_BACKEND_PROXY');

  // ── Chatbot limits ────────────────────────────────────────────────────────
  static const int chatMaxInputChars = 500;
  static const int chatMaxHistoryTurns = 10;

  // ── Deezer API (FREE — no key required) ───────────────────────────────────
  static const String deezerBaseUrl = 'https://api.deezer.com';
  static const String deezerChartsUrl =
      'https://api.deezer.com/chart/0/tracks?limit=30';

  // ── Anomaly Detection ─────────────────────────────────────────────────────
  static const double anomalyZScoreThreshold = 2.5;
  static const int anomalyMinDataPoints = 5;

  // ── AI severity thresholds (used by AiCubit + AiEnergyCubit) ──────────
  static const double aiWattsWarning = 80;
  static const double aiWattsDanger = 120;
  static const double aiWattsCritical = 180;

  static const double aiAmpsWarning = 1.2;
  static const double aiAmpsDanger = 1.8;
  static const double aiAmpsCritical = 2.5;

  // ── Room suffix map ───────────────────────────────────────────────────────
  static const Map<String, String> roomSuffixMap = {
    'LR': 'Living Room',
    'BR': 'Bedroom',
    'K': 'Kitchen',
    'B': 'Bathroom',
    'R2': 'Room 2',
  };

  // ── Design ────────────────────────────────────────────────────────────────
  static const Duration animDuration = Duration(milliseconds: 300);
  static const Duration fastAnim = Duration(milliseconds: 150);
}

// ── Room registry ─────────────────────────────────────────────────────────────
abstract class RoomRegistry {
  static const List<Map<String, String>> rooms = [
    {'id': '1', 'name': 'LIVING ROOM', 'image': 'assets/images/0.jpeg'},
    {'id': '2', 'name': 'DINING ROOM', 'image': 'assets/images/2.jpeg'},
    {'id': '3', 'name': 'KITCHEN', 'image': 'assets/images/3.jpeg'},
    {'id': '4', 'name': 'BEDROOM', 'image': 'assets/images/4.jpeg'},
    {'id': '5', 'name': 'BATHROOM', 'image': 'assets/images/1.jpeg'},
  ];
}
