import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Waffar'**
  String get appName;

  /// No description provided for @selectRoom.
  ///
  /// In en, this message translates to:
  /// **'Select a Room'**
  String get selectRoom;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @aiLiveTrend.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get aiLiveTrend;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkEnabled.
  ///
  /// In en, this message translates to:
  /// **'Dark theme enabled'**
  String get darkEnabled;

  /// No description provided for @lightEnabled.
  ///
  /// In en, this message translates to:
  /// **'Light theme enabled'**
  String get lightEnabled;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutSub.
  ///
  /// In en, this message translates to:
  /// **'Log out of your account'**
  String get signOutSub;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to '**
  String get welcomeTo;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @forgotPass.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPass;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get hasAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @errUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get errUserNotFound;

  /// No description provided for @errWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get errWrongPassword;

  /// No description provided for @errEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get errEmailInUse;

  /// No description provided for @errWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters and include letters and numbers.'**
  String get errWeakPassword;

  /// No description provided for @errInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get errInvalidCredentials;

  /// No description provided for @errPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get errPasswordRequired;

  /// No description provided for @errInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get errInvalidEmail;

  /// No description provided for @errTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait and try again.'**
  String get errTooManyRequests;

  /// No description provided for @errNoNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errNoNetwork;

  /// No description provided for @errDisabledAccount.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get errDisabledAccount;

  /// No description provided for @errOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is not enabled.'**
  String get errOperationNotAllowed;

  /// No description provided for @errAuthGeneric.
  ///
  /// In en, this message translates to:
  /// **'Authentication error. Please try again.'**
  String get errAuthGeneric;

  /// No description provided for @errGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errGeneric;

  /// No description provided for @allAlreadyOff.
  ///
  /// In en, this message translates to:
  /// **'All devices were already off'**
  String get allAlreadyOff;

  /// No description provided for @emergencyHardwareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send the shutoff command to the physical device! Cut the power manually.'**
  String get emergencyHardwareFailed;

  /// No description provided for @emergencyFailed.
  ///
  /// In en, this message translates to:
  /// **'Emergency shutoff failed. Please try again.'**
  String get emergencyFailed;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feelsLike;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search city, e.g. Cairo…'**
  String get searchCity;

  /// No description provided for @forecast3Day.
  ///
  /// In en, this message translates to:
  /// **'3-Day Forecast'**
  String get forecast3Day;

  /// No description provided for @predictiveComfort.
  ///
  /// In en, this message translates to:
  /// **'Predictive Comfort'**
  String get predictiveComfort;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @searchForCity.
  ///
  /// In en, this message translates to:
  /// **'Search for a city to see the weather'**
  String get searchForCity;

  /// No description provided for @cityNotFound.
  ///
  /// In en, this message translates to:
  /// **'City not found. Please check the name.'**
  String get cityNotFound;

  /// No description provided for @energyDashboard.
  ///
  /// In en, this message translates to:
  /// **'Energy Dashboard'**
  String get energyDashboard;

  /// No description provided for @totalKwh.
  ///
  /// In en, this message translates to:
  /// **'Total kWh'**
  String get totalKwh;

  /// No description provided for @estimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Est. Cost'**
  String get estimatedCost;

  /// No description provided for @byRoom.
  ///
  /// In en, this message translates to:
  /// **'By Room'**
  String get byRoom;

  /// No description provided for @topDevices.
  ///
  /// In en, this message translates to:
  /// **'Top Consuming Devices'**
  String get topDevices;

  /// No description provided for @electricityRate.
  ///
  /// In en, this message translates to:
  /// **'Electricity Rate'**
  String get electricityRate;

  /// No description provided for @aiDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Dashboard'**
  String get aiDashboardTitle;

  /// No description provided for @connectingFirebaseRtdb.
  ///
  /// In en, this message translates to:
  /// **'Connecting to the server…'**
  String get connectingFirebaseRtdb;

  /// No description provided for @aiRecommendation.
  ///
  /// In en, this message translates to:
  /// **'AI RECOMMENDATION'**
  String get aiRecommendation;

  /// No description provided for @liveEnergySnapshot.
  ///
  /// In en, this message translates to:
  /// **'LIVE ENERGY SNAPSHOT'**
  String get liveEnergySnapshot;

  /// No description provided for @aiProbability.
  ///
  /// In en, this message translates to:
  /// **'AI PROBABILITY'**
  String get aiProbability;

  /// No description provided for @liveConsumptionChart.
  ///
  /// In en, this message translates to:
  /// **'LIVE CONSUMPTION CHART'**
  String get liveConsumptionChart;

  /// No description provided for @topDevicesBreakdown.
  ///
  /// In en, this message translates to:
  /// **'TOP DEVICES BREAKDOWN'**
  String get topDevicesBreakdown;

  /// No description provided for @systemHealth.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM HEALTH'**
  String get systemHealth;

  /// No description provided for @powerByRoom.
  ///
  /// In en, this message translates to:
  /// **'POWER BY ROOM'**
  String get powerByRoom;

  /// No description provided for @topConsumingDevices.
  ///
  /// In en, this message translates to:
  /// **'TOP CONSUMING DEVICES'**
  String get topConsumingDevices;

  /// No description provided for @liveWatts.
  ///
  /// In en, this message translates to:
  /// **'Live Watts'**
  String get liveWatts;

  /// No description provided for @totalKwhLabel.
  ///
  /// In en, this message translates to:
  /// **'Total kWh'**
  String get totalKwhLabel;

  /// No description provided for @billLabel.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get billLabel;

  /// No description provided for @noEnergyDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No energy data available'**
  String get noEnergyDataAvailable;

  /// No description provided for @noDeviceDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No device data'**
  String get noDeviceDataAvailable;

  /// No description provided for @predictedMonthly.
  ///
  /// In en, this message translates to:
  /// **'Predicted monthly'**
  String get predictedMonthly;

  /// No description provided for @lastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced'**
  String get lastSynced;

  /// No description provided for @electricityRateTitle.
  ///
  /// In en, this message translates to:
  /// **'Electricity Rate'**
  String get electricityRateTitle;

  /// No description provided for @electricityRateSuffix.
  ///
  /// In en, this message translates to:
  /// **'EGP/kWh'**
  String get electricityRateSuffix;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @aiStatusOverview.
  ///
  /// In en, this message translates to:
  /// **'AI Status Overview'**
  String get aiStatusOverview;

  /// No description provided for @connectingFirebase.
  ///
  /// In en, this message translates to:
  /// **'Connecting to the server…'**
  String get connectingFirebase;

  /// No description provided for @updatedJustNow.
  ///
  /// In en, this message translates to:
  /// **'Updated just now'**
  String get updatedJustNow;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @loadingRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Loading recommendation…'**
  String get loadingRecommendation;

  /// No description provided for @noRecommendationAvailable.
  ///
  /// In en, this message translates to:
  /// **'No recommendation available.'**
  String get noRecommendationAvailable;

  /// No description provided for @highSeverity.
  ///
  /// In en, this message translates to:
  /// **'High Severity'**
  String get highSeverity;

  /// No description provided for @anomalyDetected.
  ///
  /// In en, this message translates to:
  /// **'Unusual Consumption Detected'**
  String get anomalyDetected;

  /// No description provided for @recommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get recommendation;

  /// No description provided for @basedOnLatestAiDecision.
  ///
  /// In en, this message translates to:
  /// **'Based on latest AI decision.'**
  String get basedOnLatestAiDecision;

  /// No description provided for @noRecommendation.
  ///
  /// In en, this message translates to:
  /// **'No recommendation available.'**
  String get noRecommendation;

  /// No description provided for @voltage.
  ///
  /// In en, this message translates to:
  /// **'Voltage'**
  String get voltage;

  /// No description provided for @amperes.
  ///
  /// In en, this message translates to:
  /// **'Amperes'**
  String get amperes;

  /// No description provided for @uptime.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get uptime;

  /// No description provided for @aiEnergyDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'AI ENERGY DASHBOARD'**
  String get aiEnergyDashboardTitle;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @forecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get forecast;

  /// No description provided for @heatmapDecision.
  ///
  /// In en, this message translates to:
  /// **'Decision'**
  String get heatmapDecision;

  /// No description provided for @heatmapVoltage.
  ///
  /// In en, this message translates to:
  /// **'Voltage'**
  String get heatmapVoltage;

  /// No description provided for @heatmapHumidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get heatmapHumidity;

  /// No description provided for @heatmapTemp.
  ///
  /// In en, this message translates to:
  /// **'Temp'**
  String get heatmapTemp;

  /// No description provided for @anomalyScore.
  ///
  /// In en, this message translates to:
  /// **'ANOMALY SCORE'**
  String get anomalyScore;

  /// No description provided for @anomaly.
  ///
  /// In en, this message translates to:
  /// **'Anomaly'**
  String get anomaly;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @decisionNormal.
  ///
  /// In en, this message translates to:
  /// **'NORMAL'**
  String get decisionNormal;

  /// No description provided for @decisionWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING'**
  String get decisionWarning;

  /// No description provided for @decisionDanger.
  ///
  /// In en, this message translates to:
  /// **'DANGER'**
  String get decisionDanger;

  /// No description provided for @decisionAnomaly.
  ///
  /// In en, this message translates to:
  /// **'ANOMALY'**
  String get decisionAnomaly;

  /// No description provided for @decisionCritical.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL'**
  String get decisionCritical;

  /// No description provided for @probabilitySignal.
  ///
  /// In en, this message translates to:
  /// **'Probability signal'**
  String get probabilitySignal;

  /// No description provided for @anomalyAlerts.
  ///
  /// In en, this message translates to:
  /// **'Unusual Consumption Alerts'**
  String get anomalyAlerts;

  /// No description provided for @monitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get monitoring;

  /// No description provided for @allClear.
  ///
  /// In en, this message translates to:
  /// **'All Clear'**
  String get allClear;

  /// No description provided for @noAnomalies.
  ///
  /// In en, this message translates to:
  /// **'No unusual power consumption detected.'**
  String get noAnomalies;

  /// No description provided for @monitoringLabel.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get monitoringLabel;

  /// No description provided for @allClearMessage.
  ///
  /// In en, this message translates to:
  /// **'All devices operating normally'**
  String get allClearMessage;

  /// No description provided for @noAnomaliesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No unusual consumption'**
  String get noAnomaliesSubtitle;

  /// No description provided for @anomalyAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Unusual Consumption Alerts'**
  String get anomalyAlertsTitle;

  /// No description provided for @allOff.
  ///
  /// In en, this message translates to:
  /// **'All Off'**
  String get allOff;

  /// No description provided for @emergencyShutoff.
  ///
  /// In en, this message translates to:
  /// **'Emergency Shutoff'**
  String get emergencyShutoff;

  /// No description provided for @shutoffConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will turn OFF ALL devices immediately. Are you sure?'**
  String get shutoffConfirm;

  /// No description provided for @shutOffAll.
  ///
  /// In en, this message translates to:
  /// **'Shut Off Everything'**
  String get shutOffAll;

  /// No description provided for @shuttingOff.
  ///
  /// In en, this message translates to:
  /// **'Shutting off…'**
  String get shuttingOff;

  /// No description provided for @emergencyActivated.
  ///
  /// In en, this message translates to:
  /// **'⚡ Emergency shutdown activated'**
  String get emergencyActivated;

  /// No description provided for @shutoffEverythingLabel.
  ///
  /// In en, this message translates to:
  /// **'Shut Off Everything'**
  String get shutoffEverythingLabel;

  /// No description provided for @shutoffConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will turn OFF ALL devices immediately.\n\nAre you sure?'**
  String get shutoffConfirmMessage;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @waffarAI.
  ///
  /// In en, this message translates to:
  /// **'Waffar AI'**
  String get waffarAI;

  /// No description provided for @smartAssist.
  ///
  /// In en, this message translates to:
  /// **'Smart Home Assistant'**
  String get smartAssist;

  /// No description provided for @askHome.
  ///
  /// In en, this message translates to:
  /// **'Ask about your home…'**
  String get askHome;

  /// No description provided for @clearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get clearChat;

  /// No description provided for @chatWelcome.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m Waffar AI 👋\nAsk me anything about your smart home — devices, energy, weather.'**
  String get chatWelcome;

  /// No description provided for @chatbotApiKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'The AI assistant is not set up yet. Please contact support.'**
  String get chatbotApiKeyMissing;

  /// No description provided for @chatbotApiKeyInvalid.
  ///
  /// In en, this message translates to:
  /// **'The AI assistant could not be authorised. Please try again later.'**
  String get chatbotApiKeyInvalid;

  /// No description provided for @chatbotNetworkError.
  ///
  /// In en, this message translates to:
  /// **'📵 Network error. Check your connection.'**
  String get chatbotNetworkError;

  /// No description provided for @chatbotGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get chatbotGenericError;

  /// No description provided for @chatbotEmptyResponse.
  ///
  /// In en, this message translates to:
  /// **'The assistant returned an empty response. Please try again.'**
  String get chatbotEmptyResponse;

  /// No description provided for @chatbotRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Rate limit reached. Wait a moment and try again.'**
  String get chatbotRateLimited;

  /// No description provided for @lights.
  ///
  /// In en, this message translates to:
  /// **'Lights'**
  String get lights;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @airConditioning.
  ///
  /// In en, this message translates to:
  /// **'Air conditioning'**
  String get airConditioning;

  /// No description provided for @lightIntensity.
  ///
  /// In en, this message translates to:
  /// **'Light intensity'**
  String get lightIntensity;

  /// No description provided for @airHumidity.
  ///
  /// In en, this message translates to:
  /// **'Air humidity'**
  String get airHumidity;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @controls.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get controls;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @cool.
  ///
  /// In en, this message translates to:
  /// **'Cool'**
  String get cool;

  /// No description provided for @heat.
  ///
  /// In en, this message translates to:
  /// **'Heat'**
  String get heat;

  /// No description provided for @fan.
  ///
  /// In en, this message translates to:
  /// **'Fan'**
  String get fan;

  /// No description provided for @dry.
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get dry;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @mid.
  ///
  /// In en, this message translates to:
  /// **'Mid'**
  String get mid;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @simulation.
  ///
  /// In en, this message translates to:
  /// **'Simulation'**
  String get simulation;

  /// No description provided for @hardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get hardware;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @tapDetails.
  ///
  /// In en, this message translates to:
  /// **'tap for details'**
  String get tapDetails;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @liveStatus.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get liveStatus;

  /// No description provided for @warningStatus.
  ///
  /// In en, this message translates to:
  /// **'WARN'**
  String get warningStatus;

  /// No description provided for @offlineStatus.
  ///
  /// In en, this message translates to:
  /// **'OFFLINE'**
  String get offlineStatus;

  /// No description provided for @unknownStatus.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get unknownStatus;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @watts.
  ///
  /// In en, this message translates to:
  /// **'Watts'**
  String get watts;

  /// No description provided for @kwh.
  ///
  /// In en, this message translates to:
  /// **'kWh'**
  String get kwh;

  /// No description provided for @volts.
  ///
  /// In en, this message translates to:
  /// **'Volts'**
  String get volts;

  /// No description provided for @amps.
  ///
  /// In en, this message translates to:
  /// **'Amps'**
  String get amps;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get lastUpdated;

  /// No description provided for @simControl.
  ///
  /// In en, this message translates to:
  /// **'Sim Control'**
  String get simControl;

  /// No description provided for @hwControl.
  ///
  /// In en, this message translates to:
  /// **'HW Control'**
  String get hwControl;

  /// No description provided for @simSource.
  ///
  /// In en, this message translates to:
  /// **'Source: Simulation'**
  String get simSource;

  /// No description provided for @hwSource.
  ///
  /// In en, this message translates to:
  /// **'Source: Hardware'**
  String get hwSource;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @openMusicPlayer.
  ///
  /// In en, this message translates to:
  /// **'Open Music Player'**
  String get openMusicPlayer;

  /// No description provided for @noSongPlaying.
  ///
  /// In en, this message translates to:
  /// **'Nothing playing'**
  String get noSongPlaying;

  /// No description provided for @searchRooms.
  ///
  /// In en, this message translates to:
  /// **'Search Rooms'**
  String get searchRooms;

  /// No description provided for @noRoomsFound.
  ///
  /// In en, this message translates to:
  /// **'No rooms found'**
  String get noRoomsFound;

  /// No description provided for @searchRoomHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Living Room, Kitchen...'**
  String get searchRoomHint;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Energy Dashboard'**
  String get dashboardTitle;

  /// No description provided for @liveBadgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get liveBadgeLabel;

  /// No description provided for @systemIndicatorsTitle.
  ///
  /// In en, this message translates to:
  /// **'System Indicators'**
  String get systemIndicatorsTitle;

  /// No description provided for @firestoreRealtimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-time updates'**
  String get firestoreRealtimeSubtitle;

  /// No description provided for @liveSnapshotTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Energy Snapshot'**
  String get liveSnapshotTitle;

  /// No description provided for @firebaseRealtimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-time data'**
  String get firebaseRealtimeSubtitle;

  /// No description provided for @anomalyAlertsSection.
  ///
  /// In en, this message translates to:
  /// **'Unusual Consumption Alerts'**
  String get anomalyAlertsSection;

  /// No description provided for @activeAnomalySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unusual consumption detected by AI'**
  String get activeAnomalySubtitle;

  /// No description provided for @simulatorLabel.
  ///
  /// In en, this message translates to:
  /// **'Simulator'**
  String get simulatorLabel;

  /// No description provided for @hardwareDeviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Hardware Device'**
  String get hardwareDeviceLabel;

  /// No description provided for @aiAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get aiAnalysisTitle;

  /// No description provided for @simPlusEspSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Simulator + Real ESP32'**
  String get simPlusEspSubtitle;

  /// No description provided for @powerByRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Power by Room'**
  String get powerByRoomTitle;

  /// No description provided for @activeRoomsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'active rooms'**
  String get activeRoomsSubtitle;

  /// No description provided for @topDevicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Consuming Devices'**
  String get topDevicesTitle;

  /// No description provided for @topFiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Top 5 devices by consumption'**
  String get topFiveSubtitle;

  /// No description provided for @liveSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Live Summary'**
  String get liveSummaryLabel;

  /// No description provided for @totalConsumptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Consumption'**
  String get totalConsumptionLabel;

  /// No description provided for @systemStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'System Status'**
  String get systemStatusLabel;

  /// No description provided for @electricityRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Electricity Rate'**
  String get electricityRateLabel;

  /// No description provided for @electricityRateUnit.
  ///
  /// In en, this message translates to:
  /// **'EGP / kWh'**
  String get electricityRateUnit;

  /// No description provided for @editLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editLabel;

  /// No description provided for @lastUpdatedPrefix.
  ///
  /// In en, this message translates to:
  /// **'Last updated:'**
  String get lastUpdatedPrefix;

  /// No description provided for @anomalyDetectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Detected by Z-score analysis of live kWh readings.'**
  String get anomalyDetectionInfo;

  /// No description provided for @deviceControl.
  ///
  /// In en, this message translates to:
  /// **'Device Control'**
  String get deviceControl;

  /// No description provided for @noDevices.
  ///
  /// In en, this message translates to:
  /// **'No Devices'**
  String get noDevices;

  /// No description provided for @hardwareOffline.
  ///
  /// In en, this message translates to:
  /// **'Hardware Offline'**
  String get hardwareOffline;

  /// No description provided for @noHardwareConnected.
  ///
  /// In en, this message translates to:
  /// **'No Hardware Connected'**
  String get noHardwareConnected;

  /// No description provided for @hardwareMonitor.
  ///
  /// In en, this message translates to:
  /// **'Hardware Monitor'**
  String get hardwareMonitor;

  /// No description provided for @hardwareDevices.
  ///
  /// In en, this message translates to:
  /// **'Hardware Devices (Offline)'**
  String get hardwareDevices;

  /// No description provided for @aiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get aiAnalysis;

  /// No description provided for @allDeviceDataFromAi.
  ///
  /// In en, this message translates to:
  /// **'All device data is read from AI analysis'**
  String get allDeviceDataFromAi;

  /// No description provided for @realDeviceControl.
  ///
  /// In en, this message translates to:
  /// **'Real Device Control'**
  String get realDeviceControl;

  /// No description provided for @commandSent.
  ///
  /// In en, this message translates to:
  /// **'✅ Command sent: '**
  String get commandSent;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'❌ Error: '**
  String get error;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get resetButton;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy;

  /// No description provided for @controlSystem.
  ///
  /// In en, this message translates to:
  /// **'Control System'**
  String get controlSystem;

  /// No description provided for @sendCommand.
  ///
  /// In en, this message translates to:
  /// **'Send Command'**
  String get sendCommand;

  /// No description provided for @commandFailed.
  ///
  /// In en, this message translates to:
  /// **'Command Failed'**
  String get commandFailed;

  /// No description provided for @awaitingResponse.
  ///
  /// In en, this message translates to:
  /// **'Awaiting response...'**
  String get awaitingResponse;

  /// No description provided for @deviceStatus.
  ///
  /// In en, this message translates to:
  /// **'Device Status'**
  String get deviceStatus;

  /// No description provided for @turnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn On'**
  String get turnOn;

  /// No description provided for @turnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn Off'**
  String get turnOff;

  /// No description provided for @powerOn.
  ///
  /// In en, this message translates to:
  /// **'Power On'**
  String get powerOn;

  /// No description provided for @powerOff.
  ///
  /// In en, this message translates to:
  /// **'Power Off'**
  String get powerOff;

  /// No description provided for @lastCommand.
  ///
  /// In en, this message translates to:
  /// **'Last Command'**
  String get lastCommand;

  /// No description provided for @commandStatus.
  ///
  /// In en, this message translates to:
  /// **'Command Status'**
  String get commandStatus;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @executed.
  ///
  /// In en, this message translates to:
  /// **'Executed'**
  String get executed;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get timeout;

  /// No description provided for @electricityRateHint.
  ///
  /// In en, this message translates to:
  /// **'1.25'**
  String get electricityRateHint;

  /// No description provided for @devicesTurnedOff.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 device turned off} other{{n} devices turned off}}'**
  String devicesTurnedOff(int n);

  /// No description provided for @updatedMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{m, plural, =1{Updated 1 min ago} other{Updated {m} min ago}}'**
  String updatedMinutesAgo(int m);

  /// No description provided for @hwSensorsLive.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hardware sensor streaming live} other{{count} hardware sensors streaming live}}'**
  String hwSensorsLive(int count);

  /// No description provided for @viewDevices.
  ///
  /// In en, this message translates to:
  /// **'View devices'**
  String get viewDevices;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// No description provided for @noRoomData.
  ///
  /// In en, this message translates to:
  /// **'No room data available'**
  String get noRoomData;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com'**
  String get emailHint;

  /// No description provided for @onboardTitle1.
  ///
  /// In en, this message translates to:
  /// **'Control all your devices'**
  String get onboardTitle1;

  /// No description provided for @onboardDesc1.
  ///
  /// In en, this message translates to:
  /// **'Manage your smart home easily and efficiently from one place.'**
  String get onboardDesc1;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Beautiful interface'**
  String get onboardTitle2;

  /// No description provided for @onboardDesc2.
  ///
  /// In en, this message translates to:
  /// **'A comfortable and modern user experience designed for you.'**
  String get onboardDesc2;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardTitle3;

  /// No description provided for @onboardDesc3.
  ///
  /// In en, this message translates to:
  /// **'Start controlling your home now with advanced features.'**
  String get onboardDesc3;

  /// No description provided for @prompt1.
  ///
  /// In en, this message translates to:
  /// **'What is the current AI status?'**
  String get prompt1;

  /// No description provided for @prompt2.
  ///
  /// In en, this message translates to:
  /// **'Which device uses the most power?'**
  String get prompt2;

  /// No description provided for @prompt3.
  ///
  /// In en, this message translates to:
  /// **'What is my current electricity bill?'**
  String get prompt3;

  /// No description provided for @prompt4.
  ///
  /// In en, this message translates to:
  /// **'Is there any unusual consumption?'**
  String get prompt4;

  /// No description provided for @prompt5.
  ///
  /// In en, this message translates to:
  /// **'What is the live wattage right now?'**
  String get prompt5;

  /// No description provided for @prompt6.
  ///
  /// In en, this message translates to:
  /// **'Should I turn off the AC?'**
  String get prompt6;

  /// No description provided for @prompt7.
  ///
  /// In en, this message translates to:
  /// **'Explain the CRITICAL warning'**
  String get prompt7;

  /// No description provided for @prompt8.
  ///
  /// In en, this message translates to:
  /// **'How much will I pay this month?'**
  String get prompt8;

  /// No description provided for @acAdviceVeryHot.
  ///
  /// In en, this message translates to:
  /// **'It\'s very hot outside. Recommend AC at 22°C.'**
  String get acAdviceVeryHot;

  /// No description provided for @acAdviceWarm.
  ///
  /// In en, this message translates to:
  /// **'Warm outside. Recommend AC at 24°C.'**
  String get acAdviceWarm;

  /// No description provided for @acAdviceCold.
  ///
  /// In en, this message translates to:
  /// **'Cold outside. Consider heating to 22°C.'**
  String get acAdviceCold;

  /// No description provided for @sevNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get sevNormal;

  /// No description provided for @sevWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get sevWarning;

  /// No description provided for @sevDanger.
  ///
  /// In en, this message translates to:
  /// **'Danger'**
  String get sevDanger;

  /// No description provided for @sevCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get sevCritical;

  /// No description provided for @healthHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthHealthy;

  /// No description provided for @healthCaution.
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get healthCaution;

  /// No description provided for @healthCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get healthCritical;

  /// No description provided for @healthLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get healthLoading;

  /// No description provided for @healthAnalysing.
  ///
  /// In en, this message translates to:
  /// **'Analysing data…'**
  String get healthAnalysing;

  /// No description provided for @recNormal.
  ///
  /// In en, this message translates to:
  /// **'✅ System operating normally. Power consumption is within safe range.'**
  String get recNormal;

  /// No description provided for @musicSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search songs, artists…'**
  String get musicSearchHint;

  /// No description provided for @musicLoadingCharts.
  ///
  /// In en, this message translates to:
  /// **'Loading top charts…'**
  String get musicLoadingCharts;

  /// No description provided for @musicTopCharts.
  ///
  /// In en, this message translates to:
  /// **'TOP CHARTS'**
  String get musicTopCharts;

  /// No description provided for @musicResultsFor.
  ///
  /// In en, this message translates to:
  /// **'RESULTS FOR'**
  String get musicResultsFor;

  /// No description provided for @recWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ WARNING — Elevated consumption ({watts}W). Monitor your devices.'**
  String recWarning(String watts);

  /// No description provided for @recDanger.
  ///
  /// In en, this message translates to:
  /// **'🚨 DANGER — High load detected ({watts}W / {amps}A). Turn off non-essential devices.'**
  String recDanger(String watts, String amps);

  /// No description provided for @recCritical.
  ///
  /// In en, this message translates to:
  /// **'☠️ CRITICAL — Extremely unsafe load ({watts}W). Disconnect devices immediately!'**
  String recCritical(String watts);

  /// No description provided for @healthSubCaution.
  ///
  /// In en, this message translates to:
  /// **'Unusual-consumption probability {pct}% • {watts} {unit} active'**
  String healthSubCaution(String pct, String watts, String unit);

  /// No description provided for @healthSubCritical.
  ///
  /// In en, this message translates to:
  /// **'Warning! Critical unusual consumption • {watts} {unit}'**
  String healthSubCritical(String watts, String unit);

  /// No description provided for @musicNoResults.
  ///
  /// In en, this message translates to:
  /// **'No tracks found for \"{query}\"'**
  String musicNoResults(String query);

  /// No description provided for @dashPullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get dashPullToRefresh;

  /// No description provided for @dashLivePower.
  ///
  /// In en, this message translates to:
  /// **'Live power'**
  String get dashLivePower;

  /// No description provided for @dashEnergyUsed.
  ///
  /// In en, this message translates to:
  /// **'Energy used'**
  String get dashEnergyUsed;

  /// No description provided for @dashEstCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated cost'**
  String get dashEstCost;

  /// No description provided for @dashMonthlyForecast.
  ///
  /// In en, this message translates to:
  /// **'Monthly forecast'**
  String get dashMonthlyForecast;

  /// No description provided for @dashActiveDevices.
  ///
  /// In en, this message translates to:
  /// **'Active devices'**
  String get dashActiveDevices;

  /// No description provided for @dashSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Today at a glance'**
  String get dashSummaryTitle;

  /// No description provided for @dashDataDelayed.
  ///
  /// In en, this message translates to:
  /// **'Data may be delayed'**
  String get dashDataDelayed;

  /// No description provided for @dashLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading your energy data…'**
  String get dashLoadingTitle;

  /// No description provided for @dashErrorHint.
  ///
  /// In en, this message translates to:
  /// **'We could not load the data. Check your connection and try again.'**
  String get dashErrorHint;

  /// No description provided for @currencyEgp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyEgp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
