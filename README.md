<div align="center">

<img src="https://github.com/user-attachments/assets/d1a6a05d-d4c3-4f16-aa1a-e974d548a581" width="100" style="border-radius:20px"/>

# 🏠 Waffar — Smart Home Control

**تطبيق Flutter ذكي للتحكم في المنزل**
محاكاة + أجهزة حقيقية · لوحة طاقة بالذكاء الاصطناعي · تنبيهات فورية · مساعد ذكي

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![BLoC](https://img.shields.io/badge/State-BLoC%20%2B%20GetIt-7B2FBE?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.0.0-00C896?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen?style=for-the-badge)
![i18n](https://img.shields.io/badge/i18n-EN%20%2F%20AR%20RTL-orange?style=for-the-badge)

</div>

---

## 📱 Screenshots

<div align="center">

| Home · Dark | Home · Light | Bedroom | Living Room |
|:-----------:|:------------:|:-------:|:-----------:|
| <img src="https://github.com/user-attachments/assets/cabf24af-06e8-4541-adb3-92c50e8e282f" width="180"/> | <img src="https://github.com/user-attachments/assets/1c91e3e2-cd55-4902-bb48-92a707f0f83f" width="180"/> | <img src="https://github.com/user-attachments/assets/a6b14c5d-e76f-402d-b2b5-1feecb375a09" width="180"/> | <img src="https://github.com/user-attachments/assets/b6737ae1-1643-410d-860d-15cecc9b4fc7" width="180"/> |

| Energy Dashboard | Hardware Monitor | Anomaly Alerts | Waffar AI |
|:----------------:|:----------------:|:--------------:|:---------:|
| <img src="https://github.com/user-attachments/assets/6d4cb33a-44d5-4840-b618-347ba4b4ca58" width="180"/> | <img src="https://github.com/user-attachments/assets/cdc9fcf6-6276-4707-a3f9-57ef69956ea3" width="180"/> | <img src="https://github.com/user-attachments/assets/48630f43-4dfe-4ec7-872f-5b9f051464dc" width="180"/> | <img src="https://github.com/user-attachments/assets/52df213d-4735-4f44-ac22-b01e708acfd0" width="180"/> |

| Weather | Side Menu | Settings · Dark | Settings · Light |
|:-------:|:---------:|:---------------:|:----------------:|
| <img src="https://github.com/user-attachments/assets/51313bee-8012-49c1-a6c1-444d2e89a06b" width="180"/> | <img src="https://github.com/user-attachments/assets/abb9b48f-b905-4006-833f-d44fb5918fdb" width="180"/> | <img src="https://github.com/user-attachments/assets/397b68eb-c5e7-4483-8ba6-504c6a6bedea" width="180"/> | <img src="https://github.com/user-attachments/assets/83ec46e9-571b-48bc-9efd-b163ec3820d4" width="180"/> |

| Device Detail | Room List | Living · Online | Bedroom · Offline |
|:-------------:|:---------:|:---------------:|:-----------------:|
| <img src="https://github.com/user-attachments/assets/fcf5355c-0bbc-4721-b7df-f4507aae9ec3" width="180"/> | <img src="https://github.com/user-attachments/assets/4719f411-59a4-4703-95e5-43cceb723624" width="180"/> | <img src="https://github.com/user-attachments/assets/41d29ced-3a38-4efa-84fb-d747387634a4" width="180"/> | <img src="https://github.com/user-attachments/assets/f523ae52-bed1-46c6-8048-001c3a541cfc" width="180"/> |

</div>

---

## ✨ Features

| # | Feature | Description |
|---|---------|-------------|
| 🏠 | **Room-Based Control** | تنقل بين الغرف بكروت صور غامرة · تحكم في كل جهاز مع مؤشرات حالة فورية |
| ⚡ | **Smart Energy Dashboard** | مراقبة الطاقة في الوقت الفعلي · kWh · واط مباشر · تكلفة شهرية بالجنيه |
| 🚨 | **Anomaly Alerts** | كشف الأحمال الخطيرة بتحليل Z-Score على قراءات Firebase المباشرة |
| 🤖 | **Waffar AI Assistant** | مساعد ذكي بسياق المنزل الكامل · ثنائي اللغة · 8 اقتراحات عربية |
| 🔌 | **Dual Mode: Sim + Hardware** | كل جهاز يعمل بوضع محاكاة أو هاردوير · Optimistic UI بأقل من 50ms |
| 🌤 | **Weather Integration** | توقعات 3 أيام · بحث بالمدينة · درجة حرارة وسرعة رياح |
| 🌙 | **Dark / Light Theme** | تبديل فوري بين الوضعين محفوظ عبر الجلسات |
| 🌍 | **Arabic RTL Support** | 235+ سلسلة نصية · تخطيط RTL كامل في 18 ملف |

---

## 📊 Stats

<div align="center">

| 📝 Localization Strings | 📱 Smart Devices | 📦 Feature Modules | 🔥 Database |
|:-----------------------:|:----------------:|:------------------:|:-----------:|
| **235+** | **14** | **12** | **100% Firestore** |

</div>

---

## 🏗️ Architecture

```
lib/
├── core/               # DI · Router · Theme · i18n (235+ strings)
│   ├── constants/
│   ├── di/             # GetIt injection setup
│   ├── l10n/           # app_localizations.dart
│   ├── router/
│   └── theme/
├── features/           # 12 feature modules
│   └── {feature}/
│       ├── data/         # datasources · models · repositories
│       ├── domain/       # entities · usecases
│       └── presentation/ # cubit · pages · widgets
└── main.dart
```

### State Management

```dart
// Global Cubits (main.dart)
MultiBlocProvider(providers: [
  BlocProvider(create: (_) => AuthCubit()),
  BlocProvider(create: (_) => LocaleCubit()),   // EN/AR
  BlocProvider(create: (_) => ThemeCubit()),    // Light/Dark
])

// Feature Cubits (via GetIt)
di.registerLazySingleton<UnifiedEnergyAiCubit>(
  () => UnifiedEnergyAiCubit(di<EnergyRepository>()),
);
```

### Optimistic UI Pattern

```dart
// 1. Update local state instantly (<50ms)
_devices[id] = _devices[id]!.copyWith(isOn: newStatus);
_emitLoaded();

// 2. Sync to Firebase in background
await _repo.toggleDevice(...);

// 3. Revert on error
_devices[id] = previousState;
_emitLoaded();
```

### Firestore Collections

| Collection | Purpose | Operation |
|-----------|---------|-----------|
| `device_states/{device}` | Current device status | READ |
| `Control/Real_Device_01` | Device commands | WRITE |
| `ai_results/{device}` | AI analysis data | READ |
| `device_alerts/{id}` | Anomaly alerts | READ/WRITE |
| `energy_daily/{date}` | Historical energy | READ |

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **Flutter 3.x** | Cross-platform UI framework |
| **Firebase Firestore** | Real-time database (RTDB fully removed) |
| **BLoC / Cubit** | Predictable state management |
| **GetIt** | Dependency injection |
| **flutter_screenutil** | Responsive sizing |
| **ESP32** | IoT hardware integration |
| **Claude AI API** | Smart home assistant |
| **Z-Score Analysis** | Anomaly detection engine |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x
- Firebase project with Firestore enabled
- `flutterfire` CLI

### Installation

```bash
# 1. Clone the repo
git clone https://github.com/your-org/waffar.git
cd waffar

# 2. Install dependencies
flutter clean && flutter pub get

# 3. Configure Firebase
flutterfire configure

# 4. Run
flutter run              # Mobile
flutter run -d chrome    # Web
```

### Build

```bash
flutter build web            # Production web
flutter build apk --release  # Android APK
```

---

## 🗺️ Roadmap

| Priority | Task | Effort |
|----------|------|--------|
| 🔴 **P0** | Integrate `UnifiedEnergyAiCubit` in all screens | 1–2 hrs |
| 🔴 **P0** | Delete deprecated cubit files | 30 min |
| 🟡 **P1** | Full Arabic mode QA — all screens | 2–3 hrs |
| 🟡 **P1** | RTL layout pass for remaining screens | 3–4 hrs |
| 🟡 **P1** | Unit tests (target > 60% coverage) | High |
| 🟢 **P2** | GoRouter migration (type-safe routes) | 1–2 days |
| 🟢 **P2** | MQTT + Firebase offline caching | 5 days |

---

## ⚠️ Known Pitfalls

| Pitfall | Solution |
|---------|----------|
| Reading from `Control` collection | Write to `Control/` · Read from `device_states/` |
| RTL breaks on new screens | Always use `EdgeInsetsDirectional` not `EdgeInsets` |
| Streams leaking memory | Dispose in cubit `close()` or use `.take(1)` |
| Lazy singleton not initialized | Call `startListening()` after `BlocProvider` creation |
| Missing i18n string crashes | Always add both EN + AR to `app_localizations.dart` |

---

<div align="center">

Built with ❤️ using **Flutter** · **Firebase** · **Claude AI**

**Waffar Smart Home · v1.0.0 · Production Ready**

</div>
