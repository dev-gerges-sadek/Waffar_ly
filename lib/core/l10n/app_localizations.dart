import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [Locale('en'), Locale('ar')];

  bool get isArabic => locale.languageCode == 'ar';

  // ── General ───────────────────────────────────────────────────────────────
  String get appName => isArabic ? 'وفّر' : 'Waffar';
  String get selectRoom => isArabic ? 'اختر غرفة' : 'Select a Room';
  String get back => isArabic ? 'رجوع' : 'Back';
  String get aiLiveTrend => isArabic ? 'مباشر' : 'Live';

  // ── Appearance ────────────────────────────────────────────────────────────
  String get appearance => isArabic ? 'المظهر' : 'Appearance';
  String get darkMode => isArabic ? 'الوضع الداكن' : 'Dark Mode';
  String get darkEnabled =>
      isArabic ? 'الوضع الداكن مفعّل' : 'Dark theme enabled';
  String get lightEnabled =>
      isArabic ? 'الوضع الفاتح مفعّل' : 'Light theme enabled';

  // ── About ─────────────────────────────────────────────────────────────────
  String get about => isArabic ? 'عن التطبيق' : 'About';
  String get appVersion => isArabic ? 'الإصدار' : 'App Version';
  String get application => isArabic ? 'التطبيق' : 'Application';

  // ── Account ───────────────────────────────────────────────────────────────
  String get account => isArabic ? 'الحساب' : 'Account';
  String get signOut => isArabic ? 'تسجيل الخروج' : 'Sign Out';
  String get signOutSub =>
      isArabic ? 'تسجيل الخروج من حسابك' : 'Log out of your account';

  // ── Auth ──────────────────────────────────────────────────────────────────
  String get welcomeTo => isArabic ? 'مرحباً بك في ' : 'Welcome to ';
  String get email => isArabic ? 'البريد الإلكتروني' : 'Email';
  String get password => isArabic ? 'كلمة المرور' : 'Password';
  String get name => isArabic ? 'الاسم' : 'Name';
  String get login => isArabic ? 'تسجيل الدخول' : 'Login';
  String get createAccount => isArabic ? 'إنشاء حساب' : 'Create Account';
  String get forgotPass => isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?';
  String get noAccount =>
      isArabic ? 'ليس لديك حساب؟ ' : "Don't have an account? ";
  String get hasAccount =>
      isArabic ? 'لديك حساب بالفعل؟ ' : 'Already have an account? ';
  String get signIn => isArabic ? 'تسجيل الدخول' : 'Sign In';
  String get signUp => isArabic ? 'إنشاء حساب' : 'Sign Up';

  // ── Auth errors (i18n-ified; previously hardcoded in error_handler.dart) ──
  String get errUserNotFound => isArabic
      ? 'لا يوجد حساب بهذا البريد.'
      : 'No account found with this email.';
  String get errWrongPassword => isArabic
      ? 'كلمة المرور غير صحيحة.'
      : 'Incorrect password. Please try again.';
  String get errEmailInUse => isArabic
      ? 'البريد الإلكتروني مسجّل مسبقاً.'
      : 'This email is already registered.';
  String get errWeakPassword => isArabic
      ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل.'
      : 'Password must be at least 6 characters.';
  String get errInvalidEmail => isArabic
      ? 'يرجى إدخال بريد إلكتروني صحيح.'
      : 'Please enter a valid email address.';
  String get errTooManyRequests => isArabic
      ? 'محاولات كثيرة. يرجى الانتظار.'
      : 'Too many attempts. Please wait and try again.';
  String get errNoNetwork =>
      isArabic ? 'لا يوجد اتصال بالإنترنت.' : 'No internet connection.';
  String get errDisabledAccount =>
      isArabic ? 'تم تعطيل هذا الحساب.' : 'This account has been disabled.';
  String get errOperationNotAllowed => isArabic
      ? 'طريقة تسجيل الدخول غير مفعّلة.'
      : 'This sign-in method is not enabled.';
  String get errAuthGeneric => isArabic
      ? 'خطأ في المصادقة. يرجى المحاولة.'
      : 'Authentication error. Please try again.';
  String get errGeneric => isArabic
      ? 'حدث خطأ. يرجى المحاولة مرة أخرى.'
      : 'Something went wrong. Please try again.';

  // ── Weather ───────────────────────────────────────────────────────────────
  String get weather => isArabic ? 'الطقس' : 'Weather';
  String get feelsLike => isArabic ? 'يبدو كأنه' : 'Feels like';
  String get searchCity =>
      isArabic ? 'ابحث عن مدينة…' : 'Search city, e.g. Cairo…';
  String get forecast3Day => isArabic ? 'توقعات 3 أيام' : '3-Day Forecast';
  String get predictiveComfort => isArabic ? 'راحة ذكية' : 'Predictive Comfort';
  String get humidity => isArabic ? 'رطوبة' : 'Humidity';
  String get wind => isArabic ? 'رياح' : 'Wind';
  String get searchForCity => isArabic
      ? 'ابحث عن مدينة لعرض الطقس'
      : 'Search for a city to see the weather';
  String get cityNotFound => isArabic
      ? 'المدينة غير موجودة. تحقق من الاسم.'
      : 'City not found. Please check the name.';

  // ── Energy ────────────────────────────────────────────────────────────────
  String get energyDashboard => isArabic ? 'لوحة الطاقة' : 'Energy Dashboard';
  String get totalKwh => isArabic ? 'إجمالي كيلوواط' : 'Total kWh';
  String get estimatedCost => isArabic ? 'التكلفة المقدرة' : 'Est. Cost';
  String get byRoom => isArabic ? 'حسب الغرفة' : 'By Room';
  String get topDevices =>
      isArabic ? 'أعلى استهلاكاً' : 'Top Consuming Devices';
  String get electricityRate => isArabic ? 'سعر الكيلوواط' : 'Electricity Rate';

  // ── Energy Dashboard (AI) ─────────────────────────────────────────────────
  String get aiDashboardTitle => isArabic ? 'لوحة وفّر AI' : 'AI Dashboard';
  String get connectingFirebaseRtdb =>
      isArabic ? 'جارٍ الاتصال بـ Firebase…' : 'Connecting to Firebase…';
  String get aiRecommendation => isArabic ? 'توصيات AI' : 'AI RECOMMENDATION';
  String get liveEnergySnapshot =>
      isArabic ? 'ملخص الطاقة المباشر' : 'LIVE ENERGY SNAPSHOT';
  String get aiProbability => isArabic ? 'احتمالات AI' : 'AI PROBABILITY';
  String get liveConsumptionChart =>
      isArabic ? 'مخطط الاستهلاك المباشر' : 'LIVE CONSUMPTION CHART';
  String get topDevicesBreakdown =>
      isArabic ? 'تفصيل أعلى الأجهزة استهلاكاً' : 'TOP DEVICES BREAKDOWN';
  String get systemHealth => isArabic ? 'حالة النظام' : 'SYSTEM HEALTH';
  String get powerByRoom => isArabic ? 'الطاقة حسب الغرفة' : 'POWER BY ROOM';
  String get topConsumingDevices =>
      isArabic ? 'أعلى الأجهزة استهلاكاً' : 'TOP CONSUMING DEVICES';
  String get liveWatts => isArabic ? 'الواط اللحظي' : 'Live Watts';
  String get totalKwhLabel => isArabic ? 'إجمالي kWh' : 'Total kWh';
  String get billLabel => isArabic ? 'الفاتورة' : 'Bill';

  // ── Energy Charts ──────────────────────────────────────────────────────────
  String get noEnergyDataAvailable =>
      isArabic ? 'لا توجد بيانات طاقة' : 'No energy data available';
  String get noDeviceDataAvailable =>
      isArabic ? 'لا توجد بيانات أجهزة' : 'No device data';
  String get predictedMonthly =>
      isArabic ? 'التكلفة الشهرية المتوقعة' : 'Predicted monthly';
  String get lastSynced => isArabic ? 'آخر مزامنة' : 'Last synced';
  String get electricityRateTitle =>
      isArabic ? 'سعر الكهرباء' : 'Electricity Rate';
  String get electricityRateHint => '1.25';
  String get electricityRateSuffix => isArabic ? 'EGP/كيلوواط.س' : 'EGP/kWh';
  String get notAvailable => isArabic ? 'غير متاح' : 'N/A';

  // ── AI Status ──────────────────────────────────────────────────────────────
  String get aiStatusOverview =>
      isArabic ? 'نظرة عامة على حالة AI' : 'AI Status Overview';
  String get connectingFirebase =>
      isArabic ? 'جارٍ الاتصال بـ Firebase…' : 'Connecting to Firebase…';
  String get updatedJustNow =>
      isArabic ? 'تم التحديث الآن' : 'Updated just now';
  String updatedMinutesAgo(int m) =>
      isArabic ? 'تم التحديث قبل $m دقيقة' : 'Updated $m min ago';
  String get source => isArabic ? 'المصدر' : 'Source';
  String get loadingRecommendation =>
      isArabic ? 'جارٍ تحميل التوصية…' : 'Loading recommendation…';
  String get noRecommendationAvailable =>
      isArabic ? 'لا توجد توصية متاحة.' : 'No recommendation available.';
  String get highSeverity => isArabic ? 'شدة عالية' : 'High Severity';
  String get anomalyDetected => isArabic ? 'تم اكتشاف خلل' : 'Anomaly Detected';
  String get recommendation => isArabic ? 'توصية' : 'Recommendation';
  String get basedOnLatestAiDecision =>
      isArabic ? 'بناءً على أحدث قرار من AI.' : 'Based on latest AI decision.';
  String get noRecommendation =>
      isArabic ? 'لا توجد توصية متاحة.' : 'No recommendation available.';

  // ── System health ─────────────────────────────────────────────────────────
  String get voltage => isArabic ? 'الجهد' : 'Voltage';
  String get amperes => isArabic ? 'الأمبير' : 'Amperes';
  String get uptime => isArabic ? 'وقت التشغيل' : 'Uptime';

  // ── AI Dashboard panel ────────────────────────────────────────────────────
  String get aiEnergyDashboardTitle =>
      isArabic ? 'لوحة طاقة AI' : 'AI ENERGY DASHBOARD';
  String get live => isArabic ? 'مباشر' : 'Live';
  String get cost => isArabic ? 'تكلفة' : 'Cost';
  String get forecast => isArabic ? 'توقعات' : 'Forecast';

  String get heatmapDecision => isArabic ? 'القرار' : 'Decision';
  String get heatmapVoltage => isArabic ? 'الجهد' : 'Voltage';
  String get heatmapHumidity => isArabic ? 'الرطوبة' : 'Humidity';
  String get heatmapTemp => isArabic ? 'الحرارة' : 'Temp';
  String get anomalyScore => isArabic ? 'مؤشر الخلل' : 'ANOMALY SCORE';

  // ── Probability ───────────────────────────────────────────────────────────
  String get anomaly => isArabic ? 'شذوذ' : 'Anomaly';
  String get normal => isArabic ? 'طبيعي' : 'Normal';
  String get decisionNormal => isArabic ? 'طبيعي' : 'NORMAL';
  String get decisionWarning => isArabic ? 'تحذير' : 'WARNING';
  String get decisionDanger => isArabic ? 'خطر' : 'DANGER';
  String get decisionAnomaly => isArabic ? 'شذوذ' : 'ANOMALY';
  String get decisionCritical => isArabic ? 'حرج' : 'CRITICAL';
  String get probabilitySignal =>
      isArabic ? 'إشارة الاحتمال' : 'Probability signal';

  // ── Anomaly alerts ────────────────────────────────────────────────────────
  String get anomalyAlerts => isArabic ? 'تنبيهات الاستهلاك' : 'Anomaly Alerts';
  String get monitoring => isArabic ? 'مراقبة' : 'Monitoring';
  String get allClear => isArabic ? 'كل شيء طبيعي' : 'All Clear';
  String get noAnomalies => isArabic
      ? 'لا يوجد استهلاك غير طبيعي.'
      : 'No unusual power consumption detected.';
  String get monitoringLabel => isArabic ? 'مراقبة' : 'Monitoring';
  String get allClearMessage => isArabic
      ? 'كل الأجهزة تعمل بشكل طبيعي'
      : 'All devices operating normally';
  String get noAnomaliesSubtitle =>
      isArabic ? 'لا توجد شذوذات مكتشفة' : 'No anomalies detected';
  String get anomalyAlertsTitle =>
      isArabic ? 'تنبيهات الشذوذ' : 'Anomaly Alerts';

  // ── Emergency ─────────────────────────────────────────────────────────────
  String get allOff => isArabic ? 'إيقاف الكل' : 'All Off';
  String get emergencyShutoff => isArabic ? 'إيقاف طارئ' : 'Emergency Shutoff';
  String get shutoffConfirm => isArabic
      ? 'سيتم إيقاف جميع الأجهزة فوراً. هل أنت متأكد؟'
      : 'This will turn OFF ALL devices immediately. Are you sure?';
  String get shutOffAll => isArabic ? 'إيقاف الكل' : 'Shut Off Everything';
  String get shuttingOff => isArabic ? 'جارٍ الإيقاف…' : 'Shutting off…';
  String get emergencyActivated =>
      isArabic ? '⚡ تم تفعيل الإيقاف الطارئ' : '⚡ Emergency shutdown activated';
  String get shutoffEverythingLabel =>
      isArabic ? 'إيقاف كل شيء' : 'Shut Off Everything';
  String get shutoffConfirmMessage => isArabic
      ? 'سيؤدي هذا إلى إيقاف تشغيل جميع الأجهزة فوراً.\n\nهل أنت متأكد؟'
      : 'This will turn OFF ALL devices immediately.\n\nAre you sure?';
  String get cancelLabel => isArabic ? 'إلغاء' : 'Cancel';

  // ── Chatbot ───────────────────────────────────────────────────────────────
  String get waffarAI => isArabic ? 'وفّر AI' : 'Waffar AI';
  String get smartAssist =>
      isArabic ? 'مساعد المنزل الذكي' : 'Smart Home Assistant';
  String get askHome => isArabic ? 'اسألني عن منزلك…' : 'Ask about your home…';
  String get clearChat => isArabic ? 'مسح المحادثة' : 'Clear chat';
  String get chatWelcome => isArabic
      ? 'مرحباً! أنا وفّر AI 👋\nاسألني أي شيء عن منزلك — الأجهزة، الطاقة، الطقس.'
      : 'Hello! I\'m Waffar AI 👋\nAsk me anything about your smart home — devices, energy, weather.';

  // ── Chatbot error messages ────────────────────────────────────────────────
  String get chatbotApiKeyMissing => isArabic
      ? '⚠️ مفتاح API غير مُعدَّ.\nيرجى إعداد المفتاح في AppConstants.'
      : '⚠️ API key not configured.\nPlease set your key in AppConstants.';
  String get chatbotApiKeyInvalid => isArabic
      ? '🔑 مفتاح API غير صحيح. تحقق من AppConstants.'
      : '🔑 Invalid API key. Check AppConstants.';
  String get chatbotNetworkError => isArabic
      ? '📵 خطأ في الاتصال. تحقق من الإنترنت.'
      : '📵 Network error. Check your connection.';
  String get chatbotGenericError => isArabic
      ? 'حدث خطأ ما. يرجى المحاولة مرة أخرى.'
      : 'Something went wrong. Please try again.';
  String get chatbotEmptyResponse => isArabic
      ? 'لم يُرجع المساعد ردًّا. حاول مجدداً.'
      : 'The assistant returned an empty response. Please try again.';
  String get chatbotRateLimited => isArabic
      ? 'تم تجاوز حد الطلبات. انتظر لحظة ثم أعد المحاولة.'
      : 'Rate limit reached. Wait a moment and try again.';

  // ── Smart Room controls ───────────────────────────────────────────────────
  String get lights => isArabic ? 'الإضاءة' : 'Lights';
  String get timer => isArabic ? 'المؤقت' : 'Timer';
  String get music => isArabic ? 'الموسيقى' : 'Music';
  String get airConditioning => isArabic ? 'التكييف' : 'Air conditioning';
  String get lightIntensity => isArabic ? 'شدة الإضاءة' : 'Light intensity';
  String get airHumidity => isArabic ? 'رطوبة الهواء' : 'Air humidity';
  String get temperature => isArabic ? 'درجة الحرارة' : 'Temperature';
  String get controls => isArabic ? 'التحكم' : 'Controls';
  String get devices => isArabic ? 'الأجهزة' : 'Devices';

  // ── AC Modes ──────────────────────────────────────────────────────────────
  String get cool => isArabic ? 'تبريد' : 'Cool';
  String get heat => isArabic ? 'تدفئة' : 'Heat';
  String get fan => isArabic ? 'مروحة' : 'Fan';
  String get dry => isArabic ? 'تجفيف' : 'Dry';

  // ── Fan speed ─────────────────────────────────────────────────────────────
  String get low => isArabic ? 'منخفض' : 'Low';
  String get mid => isArabic ? 'متوسط' : 'Mid';
  String get high => isArabic ? 'مرتفع' : 'High';

  // ── Devices ───────────────────────────────────────────────────────────────
  String get simulation => isArabic ? 'محاكاة' : 'Simulation';
  String get hardware => isArabic ? 'أجهزة' : 'Hardware';
  String get unavailable => isArabic ? 'غير متاح' : 'Unavailable';
  String get tapDetails => isArabic ? 'اضغط للتفاصيل' : 'tap for details';
  String get online => isArabic ? 'متصل' : 'Online';
  String get offline => isArabic ? 'غير متصل' : 'Offline';
  String get liveStatus => isArabic ? 'مباشر' : 'LIVE';
  String get warningStatus => isArabic ? 'تحذير' : 'WARN';
  String get offlineStatus => isArabic ? 'غير متصل' : 'OFFLINE';
  String get unknownStatus => isArabic ? 'غير معروف' : 'N/A';
  String get status => isArabic ? 'الحالة' : 'Status';
  String get watts => isArabic ? 'واط' : 'Watts';
  String get kwh => isArabic ? 'كيلوواط/س' : 'kWh';
  String get volts => isArabic ? 'فولت' : 'Volts';
  String get amps => isArabic ? 'أمبير' : 'Amps';
  String get lastUpdated => isArabic ? 'آخر تحديث' : 'Last updated';

  // ── Device detail sheet toggles ───────────────────────────────────────────
  String get simControl => isArabic ? 'تحكم محاكاة' : 'Sim Control';
  String get hwControl => isArabic ? 'تحكم أجهزة' : 'HW Control';
  String get simSource => isArabic ? 'مصدر: محاكاة' : 'Source: Simulation';
  String get hwSource => isArabic ? 'مصدر: أجهزة' : 'Source: Hardware';
  String get notConnected => isArabic ? 'غير متوفر' : 'Not connected';

  // ── Music ─────────────────────────────────────────────────────────────────
  String get openMusicPlayer =>
      isArabic ? 'فتح مشغل الموسيقى' : 'Open Music Player';
  String get noSongPlaying => isArabic ? 'لا يوجد أغنية' : 'Nothing playing';

  // ── Rooms ─────────────────────────────────────────────────────────────────
  String get searchRooms => isArabic ? 'بحث في الغرف' : 'Search Rooms';
  String get noRoomsFound => isArabic ? 'لا توجد غرف' : 'No rooms found';
  String get searchRoomHint => isArabic
      ? 'مثلاً: غرفة المعيشة، المطبخ...'
      : 'e.g. Living Room, Kitchen...';

  // ── AI Energy Dashboard ───────────────────────────────────────────────────
  String get dashboardTitle =>
      isArabic ? 'لوحة الطاقة الذكية' : 'Smart Energy Dashboard';
  String get liveBadgeLabel => isArabic ? 'مباشر' : 'Live';
  String get systemIndicatorsTitle =>
      isArabic ? 'مؤشرات النظام' : 'System Indicators';
  String get firestoreRealtimeSubtitle =>
      isArabic ? 'التحديث الفوري من Firestore' : 'Real-time from Firestore';
  String get liveSnapshotTitle =>
      isArabic ? 'لقطة الطاقة الحية' : 'Live Energy Snapshot';
  String get firebaseRealtimeSubtitle =>
      isArabic ? 'بيانات فورية من Firebase' : 'Real-time data from Firebase';
  String get anomalyAlertsSection =>
      isArabic ? 'تنبيهات الشذوذ' : 'Anomaly Alerts';
  String get activeAnomalySubtitle => isArabic
      ? 'شذوذ نشط مكتشف بواسطة الذكاء الاصطناعي'
      : 'Active anomaly detected by AI';
  String get simulatorLabel => isArabic ? 'المحاكي' : 'Simulator';
  String get hardwareDeviceLabel =>
      isArabic ? 'الجهاز الحقيقي' : 'Hardware Device';
  String get aiAnalysisTitle =>
      isArabic ? 'تحليل الذكاء الاصطناعي' : 'AI Analysis';
  String get simPlusEspSubtitle =>
      isArabic ? 'المحاكي + ESP32 الحقيقي' : 'Simulator + Real ESP32';
  String get powerByRoomTitle =>
      isArabic ? 'الطاقة حسب الغرفة' : 'Power by Room';
  String get activeRoomsSubtitle => isArabic ? 'غرفة نشطة' : 'active rooms';
  String get topDevicesTitle =>
      isArabic ? 'أعلى الأجهزة استهلاكاً' : 'Top Consuming Devices';
  String get topFiveSubtitle =>
      isArabic ? 'أعلى ٥ أجهزة بالاستهلاك' : 'Top 5 devices by consumption';
  String get liveSummaryLabel => isArabic ? 'ملخص مباشر' : 'Live Summary';
  String get totalConsumptionLabel =>
      isArabic ? 'إجمالي الاستهلاك' : 'Total Consumption';
  String get systemStatusLabel => isArabic ? 'حالة النظام' : 'System Status';
  String get electricityRateLabel =>
      isArabic ? 'سعر الكهرباء الحالي' : 'Current Electricity Rate';
  String get electricityRateUnit => isArabic ? 'جنيه / كوات' : 'EGP / kWh';
  String get editLabel => isArabic ? 'تعديل' : 'Edit';
  String get lastUpdatedPrefix => isArabic ? 'آخر تحديث:' : 'Last updated:';
  String get anomalyDetectionInfo => isArabic
      ? 'تم الكشف عن طريق تحليل Z-score على قراءات kWh المباشرة من Firebase.'
      : 'Detected by Z-score analysis on live kWh readings from Firebase.';

  // ── Device Control ────────────────────────────────────────────────────────
  String get deviceControl => isArabic ? 'التحكم في الأجهزة' : 'Device Control';
  String get noDevices => isArabic ? 'لا توجد أجهزة' : 'No Devices';
  String get hardwareOffline =>
      isArabic ? 'الأجهزة غير متصلة' : 'Hardware Offline';
  String get noHardwareConnected =>
      isArabic ? 'لا توجد أجهزة متصلة' : 'No Hardware Connected';

  // ── Hardware Monitor ──────────────────────────────────────────────────────
  String get hardwareMonitor => isArabic ? 'مراقب الأجهزة' : 'Hardware Monitor';
  String get hardwareDevices =>
      isArabic ? 'أجهزة الحواسيب' : 'Hardware Devices (Offline)';
  String get aiAnalysis => isArabic ? 'تحليل الذكاء الاصطناعي' : 'AI Analysis';
  String get allDeviceDataFromAi => isArabic
      ? 'تم الحصول على بيانات جميع الأجهزة من تحليل AI'
      : 'All device data is read from AI analysis';
  String get realDeviceControl =>
      isArabic ? 'التحكم في الجهاز الفعلي' : 'Real_Device_01 Control';
  String get commandSent =>
      isArabic ? '✅ تم إرسال الأمر: ' : '✅ Command sent: ';
  String get error => isArabic ? '❌ خطأ: ' : '❌ Error: ';
  String get resetButton => isArabic ? 'إعادة تعيين' : 'RESET';
  String get noData => isArabic ? 'لا توجد بيانات' : 'No Data';
  String get retry => isArabic ? 'إعادة محاولة' : 'Retry';
  String get loading => isArabic ? 'جاري التحميل' : 'Loading...';
  String get warning => isArabic ? 'تحذير' : 'Warning';
  String get success => isArabic ? 'نجح' : 'Success';
  String get save => isArabic ? 'حفظ' : 'Save';
  String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  String get delete => isArabic ? 'حذف' : 'Delete';
  String get edit => isArabic ? 'تعديل' : 'Edit';
  String get add => isArabic ? 'إضافة' : 'Add';
  String get close => isArabic ? 'إغلاق' : 'Close';
  String get confirm => isArabic ? 'تأكيد' : 'Confirm';
  String get settings => isArabic ? 'الإعدادات' : 'Settings';
  String get profile => isArabic ? 'الملف الشخصي' : 'Profile';
  String get logout => isArabic ? 'تسجيل الخروج' : 'Logout';
  String get language => isArabic ? 'اللغة' : 'Language';
  String get arabic => isArabic ? 'العربية' : 'Arabic';
  String get english => isArabic ? 'الإنجليزية' : 'English';
  String get theme => isArabic ? 'المظهر' : 'Theme';
  String get help => isArabic ? 'مساعدة' : 'Help';
  String get feedback => isArabic ? 'تقديم ملاحظات' : 'Feedback';
  String get contactUs => isArabic ? 'اتصل بنا' : 'Contact Us';
  String get terms => isArabic ? 'الشروط والأحكام' : 'Terms & Conditions';
  String get privacy => isArabic ? 'سياسة الخصوصية' : 'Privacy Policy';

  // ── Control System ────────────────────────────────────────────────────────
  String get controlSystem => isArabic ? 'نظام التحكم' : 'Control System';
  String get sendCommand => isArabic ? 'إرسال أمر' : 'Send Command';
  String get commandFailed => isArabic ? 'فشل الأمر' : 'Command Failed';
  String get awaitingResponse =>
      isArabic ? 'في انتظار الاستجابة...' : 'Awaiting response...';
  String get deviceStatus => isArabic ? 'حالة الجهاز' : 'Device Status';
  String get turnOn => isArabic ? 'تشغيل' : 'Turn On';
  String get turnOff => isArabic ? 'إطفاء' : 'Turn Off';
  String get powerOn => isArabic ? 'قيد التشغيل' : 'Power On';
  String get powerOff => isArabic ? 'مُطفأ' : 'Power Off';
  String get lastCommand => isArabic ? 'آخر أمر' : 'Last Command';
  String get commandStatus => isArabic ? 'حالة الأمر' : 'Command Status';
  String get pending => isArabic ? 'قيد الانتظار' : 'Pending';
  String get executed => isArabic ? 'تم التنفيذ' : 'Executed';
  String get failed => isArabic ? 'فشل' : 'Failed';
  String get timeout => isArabic ? 'انتهاء المهلة الزمنية' : 'Timeout';

  // ── Room label helper ─────────────────────────────────────────────────────
  String roomLabel(String roomKey) {
    if (!isArabic) return roomKey;
    const map = {
      'Living Room': 'غرفة المعيشة',
      'Bedroom': 'غرفة النوم',
      'Kitchen': 'المطبخ',
      'Bathroom': 'الحمام',
      'Room 2': 'الغرفة 2',
      'Other': 'أخرى',
    };
    return map[roomKey] ?? roomKey;
  }

  // ── Device and Room Name Translation ──────────────────────────────────────
  String translateDeviceOrRoomName(String name) {
    if (!isArabic) return name;

    // Device names mapping
    const deviceMap = {
      'AC_UNIT': 'وحدة تكييف الهواء',
      'AC': 'تكييف الهواء',
      'WATER_HEATER': 'سخان المياه',
      'WATER HEATER': 'سخان المياه',
      'REFRIGERATOR': 'الثلاجة',
      'FRIDGE': 'الثلاجة',
      'WASHING_MACHINE': 'الغسالة',
      'WASHING MACHINE': 'الغسالة',
      'TV': 'التلفاز',
      'TELEVISION': 'التلفاز',
      'MICROWAVE': 'الميكروويف',
      'OVEN': 'الفرن',
      'DISHWASHER': 'غسالة الأطباق',
      'LIGHTS': 'الأضواء',
      'LIGHTING': 'الإضاءة',
      'FAN': 'المروحة',
      'PUMP': 'المضخة',
      'WATER_PUMP': 'مضخة المياه',
      'WATER PUMP': 'مضخة المياه',
      'HEATER': 'السخان',
      'COOLER': 'المبرد',
      'DRYER': 'المجفف',
      'LAPTOP': 'الحاسوب المحمول',
      'COMPUTER': 'الحاسوب',
      'CHARGER': 'جهاز الشحن',
      'ROUTER': 'جهاز التوجيه',
      'MODEM': 'المودم',
      'PRINTER': 'الطابعة',
      'DEVICE': 'الجهاز',

      // Room names with underscores
      'LIVING_ROOM': 'غرفة المعيشة',
      'LIVING ROOM': 'غرفة المعيشة',
      'BEDROOM': 'غرفة النوم',
      'BED_ROOM': 'غرفة النوم',
      'KITCHEN': 'المطبخ',
      'BATHROOM': 'الحمام',
      'BATH_ROOM': 'الحمام',
      'HALLWAY': 'الممر',
      'HALL_WAY': 'الممر',
      'GARAGE': 'المرآب',
      'TERRACE': 'الشرفة',
      'BALCONY': 'الشرفة',
    };

    return deviceMap[name.toUpperCase()] ?? name;
  }

  // ── Recommendation Translation ─────────────────────────────────────────────
  String translateRecommendation(String englishRecommendation) {
    const Map<String, String> recommendations = {
      'DANGER — Unsafe load detected. Disconnect high-power devices immediately!':
          'خطر — تم اكتشاف حمل غير آمن. قطع الأجهزة عالية الطاقة على الفور!',
      'WARNING — Consumption spike detected. Consider reducing load.':
          'تحذير — تم اكتشاف ارتفاع في الاستهلاك. يرجى تقليل الحمل.',
      'Monitor power consumption closely over the next hour.':
          'راقب استهلاك الطاقة عن كثب خلال الساعة القادمة.',
      'Device may be malfunctioning. Schedule maintenance check.':
          'قد يكون الجهاز معطلاً. يرجى جدولة فحص الصيانة.',
      'High energy consumption detected from this device.':
          'تم اكتشاف استهلاك طاقة عالي من هذا الجهاز.',
      'Consider unplugging devices when not in use.':
          'فكر في فصل الأجهزة عند عدم الاستخدام.',
      'No recommendation available': 'لا توجد توصيات متاحة',
    };
    return recommendations[englishRecommendation] ?? englishRecommendation;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
