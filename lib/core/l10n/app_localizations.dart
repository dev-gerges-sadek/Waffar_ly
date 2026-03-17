import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [Locale('en'), Locale('ar')];

  bool get isArabic => locale.languageCode == 'ar';

  // ── General ───────────────────────────────────────────────────────────────
  String get appName        => isArabic ? 'وفّر'              : 'Waffar';
  String get selectRoom     => isArabic ? 'اختر غرفة'         : 'Select a Room';
  String get settings       => isArabic ? 'الإعدادات'         : 'Settings';
  String get back           => isArabic ? 'رجوع'              : 'Back';
  String get cancel         => isArabic ? 'إلغاء'             : 'Cancel';
  String get live           => isArabic ? 'مباشر'             : 'Live';
  String get save           => isArabic ? 'حفظ'               : 'Save';

  // ── Appearance ────────────────────────────────────────────────────────────
  String get appearance     => isArabic ? 'المظهر'            : 'Appearance';
  String get darkMode       => isArabic ? 'الوضع الداكن'      : 'Dark Mode';
  String get darkEnabled    => isArabic ? 'الوضع الداكن مفعّل': 'Dark theme enabled';
  String get lightEnabled   => isArabic ? 'الوضع الفاتح مفعّل': 'Light theme enabled';

  // ── About ─────────────────────────────────────────────────────────────────
  String get about          => isArabic ? 'عن التطبيق'        : 'About';
  String get appVersion     => isArabic ? 'الإصدار'           : 'App Version';
  String get application    => isArabic ? 'التطبيق'           : 'Application';

  // ── Account ───────────────────────────────────────────────────────────────
  String get account        => isArabic ? 'الحساب'            : 'Account';
  String get signOut        => isArabic ? 'تسجيل الخروج'      : 'Sign Out';
  String get signOutSub     => isArabic ? 'تسجيل الخروج من حسابك' : 'Log out of your account';

  // ── Auth ──────────────────────────────────────────────────────────────────
  String get welcomeTo      => isArabic ? 'مرحباً بك في '     : 'Welcome to ';
  String get email          => isArabic ? 'البريد الإلكتروني' : 'Email';
  String get password       => isArabic ? 'كلمة المرور'       : 'Password';
  String get name           => isArabic ? 'الاسم'             : 'Name';
  String get login          => isArabic ? 'تسجيل الدخول'      : 'Login';
  String get createAccount  => isArabic ? 'إنشاء حساب'        : 'Create Account';
  String get forgotPass     => isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?';
  String get noAccount      => isArabic ? 'ليس لديك حساب؟ '   : "Don't have an account? ";
  String get hasAccount     => isArabic ? 'لديك حساب بالفعل؟ ': 'Already have an account? ';
  String get signIn         => isArabic ? 'تسجيل الدخول'      : 'Sign In';
  String get signUp         => isArabic ? 'إنشاء حساب'        : 'Sign Up';

  // ── Weather ───────────────────────────────────────────────────────────────
  String get weather        => isArabic ? 'الطقس'             : 'Weather';
  String get feelsLike      => isArabic ? 'يبدو كأنه'         : 'Feels like';
  String get searchCity     => isArabic ? 'ابحث عن مدينة…'    : 'Search city, e.g. Cairo…';
  String get forecast3Day   => isArabic ? 'توقعات 3 أيام'     : '3-Day Forecast';
  String get predictiveComfort => isArabic ? 'راحة ذكية'      : 'Predictive Comfort';
  String get humidity       => isArabic ? 'رطوبة'             : 'Humidity';
  String get wind           => isArabic ? 'رياح'              : 'Wind';
  String get searchForCity  => isArabic
      ? 'ابحث عن مدينة لعرض الطقس'
      : 'Search for a city to see the weather';
  String get cityNotFound   => isArabic
      ? 'المدينة غير موجودة. تحقق من الاسم.'
      : 'City not found. Please check the name.';

  // ── Energy ────────────────────────────────────────────────────────────────
  String get energyDashboard => isArabic ? 'لوحة الطاقة'      : 'Energy Dashboard';
  String get totalKwh        => isArabic ? 'إجمالي كيلوواط'   : 'Total kWh';
  String get estimatedCost   => isArabic ? 'التكلفة المقدرة'  : 'Est. Cost';
  String get byRoom          => isArabic ? 'حسب الغرفة'       : 'By Room';
  String get topDevices      => isArabic ? 'أعلى استهلاكاً'   : 'Top Consuming Devices';
  String get electricityRate => isArabic ? 'سعر الكيلوواط'    : 'Electricity Rate';

  // ── Anomaly ───────────────────────────────────────────────────────────────
  String get anomalyAlerts  => isArabic ? 'تنبيهات الاستهلاك' : 'Anomaly Alerts';
  String get monitoring     => isArabic ? 'مراقبة'            : 'Monitoring';
  String get allClear       => isArabic ? 'كل شيء طبيعي'      : 'All Clear';
  String get noAnomalies    => isArabic
      ? 'لا يوجد استهلاك غير طبيعي.'
      : 'No unusual power consumption detected.';

  // ── Emergency ─────────────────────────────────────────────────────────────
  String get allOff           => isArabic ? 'إيقاف الكل'      : 'All Off';
  String get emergencyShutoff => isArabic ? 'إيقاف طارئ'      : 'Emergency Shutoff';
  String get shutoffConfirm   => isArabic
      ? 'سيتم إيقاف جميع الأجهزة فوراً. هل أنت متأكد؟'
      : 'This will turn OFF ALL devices immediately. Are you sure?';
  String get shutOffAll       => isArabic ? 'إيقاف الكل'      : 'Shut Off Everything';
  String get shuttingOff      => isArabic ? 'جارٍ الإيقاف…'   : 'Shutting off…';

  // ── Chatbot ───────────────────────────────────────────────────────────────
  String get waffarAI      => isArabic ? 'وفّر AI'            : 'Waffar AI';
  String get smartAssist   => isArabic ? 'مساعد المنزل الذكي' : 'Smart Home Assistant';
  String get askHome       => isArabic ? 'اسألني عن منزلك…'   : 'Ask about your home…';
  String get clearChat     => isArabic ? 'مسح المحادثة'       : 'Clear chat';
  String get chatWelcome   => isArabic
      ? 'مرحباً! أنا وفّر AI 👋\nاسألني أي شيء عن منزلك — الأجهزة، الطاقة، الطقس.'
      : 'Hello! I\'m Waffar AI 👋\nAsk me anything about your smart home — devices, energy, weather.';

  // ── Smart Room controls ───────────────────────────────────────────────────
  String get lights           => isArabic ? 'الإضاءة'         : 'Lights';
  String get timer            => isArabic ? 'المؤقت'          : 'Timer';
  String get music            => isArabic ? 'الموسيقى'        : 'Music';
  String get airConditioning  => isArabic ? 'التكييف'         : 'Air conditioning';
  String get lightIntensity   => isArabic ? 'شدة الإضاءة'     : 'Light intensity';
  String get airHumidity      => isArabic ? 'رطوبة الهواء'    : 'Air humidity';
  String get temperature      => isArabic ? 'درجة الحرارة'    : 'Temperature';
  String get controls         => isArabic ? 'التحكم'          : 'Controls';
  String get devices          => isArabic ? 'الأجهزة'         : 'Devices';

  // ── AC Modes ──────────────────────────────────────────────────────────────
  String get cool  => isArabic ? 'تبريد' : 'Cool';
  String get heat  => isArabic ? 'تدفئة' : 'Heat';
  String get fan   => isArabic ? 'مروحة' : 'Fan';
  String get dry   => isArabic ? 'تجفيف' : 'Dry';

  // ── Fan speed ─────────────────────────────────────────────────────────────
  String get low   => isArabic ? 'منخفض' : 'Low';
  String get mid   => isArabic ? 'متوسط' : 'Mid';
  String get high  => isArabic ? 'مرتفع' : 'High';

  // ── Devices ───────────────────────────────────────────────────────────────
  String get simulation => isArabic ? 'محاكاة'   : 'Simulation';
  String get hardware   => isArabic ? 'أجهزة'    : 'Hardware';
  String get tapDetails => isArabic ? 'اضغط للتفاصيل' : 'tap for details';
  String get noDevices  => isArabic ? 'لا يوجد أجهزة' : 'No devices';

  // ── Music ────────────────────────────────────────────────────────────────
  String get openMusicPlayer => isArabic ? 'فتح مشغل الموسيقى' : 'Open Music Player';
  String get noSongPlaying   => isArabic ? 'لا يوجد أغنية' : 'Nothing playing';

  // ── Language ─────────────────────────────────────────────────────────────
  String get language => isArabic ? 'اللغة'       : 'Language';
  String get arabic   => isArabic ? 'العربية'     : 'Arabic';
  String get english  => isArabic ? 'الإنجليزية' : 'English';

  // ── Rooms ────────────────────────────────────────────────────────────────
  String get searchRooms     => isArabic ? 'بحث في الغرف'  : 'Search Rooms';
  String get noRoomsFound    => isArabic ? 'لا توجد غرف'   : 'No rooms found';
  String get searchRoomHint  => isArabic
      ? 'مثلاً: غرفة المعيشة، المطبخ...'
      : 'e.g. Living Room, Kitchen...';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
