# Waffar Smart Home App — Agent Instructions

> **Last Updated**: May 22, 2026 | **Status**: 🟢 Production Ready | **Build**: ✅ `flutter build web` successful

## Quick Reference

- **Project**: Waffar Smart Home Flutter app (EN/AR bilingual, RTL-aware)
- **Build command**: `flutter clean && flutter pub get && flutter run`
- **Web build**: `flutter build web`
- **Architecture**: Clean Architecture (partial) + BLoC state management + GetIt DI
- **No tests**: ⚠️ Manual QA only — be extra careful with changes

## 1. Architecture Overview

### Clean Architecture Pattern (Partial)

**Fully implemented** (Clean Architecture: domain → data → presentation):
- `lib/features/devices/` — Device state/control with full layers
- `lib/features/energy/` — Energy analytics with unified cubit
- `lib/features/ai_energy_dashboard/` — AI insights with complete layering

**Simplified** (Skip domain layer, direct cubit → Firebase):
- `lib/features/auth/` — Authentication logic
- `lib/features/chatbot/`, `emergency/`, `alert/` — Direct repos + cubits

**Architectural Impact**: When adding features, match the pattern of similar existing features (not vice versa).

### Project Structure

```
lib/
  core/              # Shared utilities, DI, routing, theme, i18n, services
  features/          # 12 feature modules (devices, energy, auth, chatbot, etc.)
  firebase_options.dart
  main.dart
```

## 2. State Management: BLoC + GetIt

### Global Cubits (in main.dart)

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthCubit()),        // Global auth state
    BlocProvider(create: (_) => LocaleCubit()),      // EN/AR selection
    BlocProvider(create: (_) => ThemeCubit()),       // Light/Dark mode
  ],
  child: ...
)
```

### Feature Cubits (registered in DI)

Example: Hardware screen uses `UnifiedEnergyAiCubit` from GetIt:

```dart
// In lib/core/di/injection.dart
di.registerLazySingleton<UnifiedEnergyAiCubit>(() => UnifiedEnergyAiCubit(...));

// In feature screen
BlocProvider(
  create: (_) => di<UnifiedEnergyAiCubit>(),
  child: BlocBuilder<UnifiedEnergyAiCubit, EnergyState>(
    builder: (context, state) => ...
  ),
)
```

### Pattern Alert

- ✅ Global cubits: Use `context.read<AuthCubit>()` directly
- ✅ Feature cubits: Use `context.read<FeatureCubit>()` OR `di<FeatureCubit>()`
- ⚠️ **Inconsistency**: Global cubits created outside GetIt in main.dart (breaking DI convention)
- ⚠️ **Risk**: Lazy singleton cubits may not init until first access

## 3. Dependency Injection (GetIt)

### Setup File

**Location**: `lib/core/di/injection.dart` → called from `main()` via `await setupDependencies()`

### Registration Pattern

```dart
final di = GetIt.instance;

Future<void> setupDependencies() async {
  // Check if already registered (prevent double registration)
  if (di.isRegistered<Type>()) return;
  
  // Register repositories (lazy singletons for Firestore repos)
  di.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(di<FirestoreDeviceDataSource>()),
  );
  
  // Register cubits (factory for stateful, lazy singleton for services)
  di.registerLazySingleton<UnifiedEnergyAiCubit>(
    () => UnifiedEnergyAiCubit(di<EnergyRepository>(), di<AiResultsRepository>()),
  );
}
```

### How to Add a New Service

1. Define the service/repository interface
2. Add implementation class
3. Register in `injection.dart`: `di.registerLazySingleton<MyService>(() => MyServiceImpl(...))`
4. Access in screens: `di<MyService>()` or in cubits during construction

**Key**: Always check `if (di.isRegistered<Type>())` before registering to avoid conflicts.

## 4. Firestore Integration

### Database Architecture

See [Waffar_App_Architecture.md](Waffar_App_Architecture.md#2-firestore-database-architecture) for complete mapping.

**Key Collections**:

| Collection | Purpose | Access Pattern |
|-----------|---------|-----------------|
| `ai_results/{device}` | AI analysis | READ `.snapshots()` |
| `device_states/{device}` | Current device status | READ `.snapshots()` |
| `Control/{device}` | **Send commands here** (replaces old `Devices/`) | WRITE `.update()` |
| `device_alerts/{id}` | Anomaly alerts | READ/WRITE |
| `energy_daily/{date}` | Historical energy | READ |
| `users/{uid}` | User profiles | READ/WRITE |

### Sending Device Commands

```dart
// In repository or cubit
await firestore.collection('Control').doc('Real_Device_01').update({
  'status': 'ON',  // or 'OFF'
  'timestamp': FieldValue.serverTimestamp(),
});
```

### Reading Device Status

```dart
// Read from device_states (NOT Control)
firestore.collection('device_states').doc('Lamp_LR_01').snapshots()
  .map((snapshot) => snapshot.data()?['status'] == 'ON')
```

### ⚠️ Known Issue: No Unsubscribe Cleanup

Data sources expose `.snapshots()` streams but no centralized cleanup. **Potential memory leak** if streams aren't disposed. Always dispose streams in cubits or use `.take(1)` if single-read only.

### Migration Complete

- ✅ Firebase Realtime Database (RTDB) completely removed
- ✅ Zero references to `firebase_database` package
- ✅ Verify: `grep -r "FirebaseDatabase" lib/` should return 0 matches

## 5. Internationalization (i18n)

### Language Support

- **English**: Full coverage (100%)
- **Arabic**: Full coverage (100%), RTL auto-enabled

### Adding New Strings

**File**: `lib/core/l10n/app_localizations.dart`

```dart
String get newString => isArabic ? 'النص العربي' : 'English text';
String get turnOn => isArabic ? 'تشغيل' : 'Turn On';
```

### RTL Awareness

**Always use directional variants** in new code:

```dart
// ❌ Wrong (LTR only)
padding: EdgeInsets.only(left: 16.w)
borderRadius: BorderRadius.only(bottomLeft: ...)

// ✅ Right (RTL-aware)
padding: EdgeInsetsDirectional.only(start: 16.w)
borderRadius: BorderRadius.only(bottomStart: ...)
```

**Applies to**: `EdgeInsets`, `Alignment`, `BorderRadius`, `Stack`, margin/padding.

**Read**: [Waffar_App_Architecture.md — Arabic Localization & RTL Support](Waffar_App_Architecture.md#3-arabic-localization--rtl-support)

## 6. Key Files to Know

### Bootstrap & Configuration

- [lib/main.dart](lib/main.dart) — App entry, MultiBlocProvider, theme/locale setup
- [lib/core/di/injection.dart](lib/core/di/injection.dart) — **Dependency registry** (modify here when adding services)
- [lib/core/router/router.dart](lib/core/router/router.dart) — Named routes, navigation logic
- [lib/firebase_options.dart](lib/firebase_options.dart) — Multi-platform Firebase config (auto-generated)

### Architecture Reference

- [lib/features/devices/](lib/features/devices) — **Best practice**: Full Clean Architecture with domain/data/presentation
- [lib/features/energy/cubit/unified_energy_ai_cubit.dart](lib/features/energy/cubit/unified_energy_ai_cubit.dart) — Unified cubit pattern
- [lib/core/l10n/app_localizations.dart](lib/core/l10n/app_localizations.dart) — i18n strings registry

### Documentation

- [Waffar_App_Architecture.md](Waffar_App_Architecture.md) — Detailed architecture, Firestore schema, session history
- [README.md](README.md) — Project overview

## 7. Build & Run Commands

### Development

```bash
# Full rebuild (clean cache)
flutter clean && flutter pub get && flutter run

# Incremental run (faster)
flutter run

# Verbose output for debugging
flutter run -v

# Run on web
flutter run -d chrome
```

### Production Builds

```bash
# Web build (used in CI/CD)
flutter clean && flutter pub get && flutter build web

# Android APK (debug)
flutter build apk --debug

# Analyze code for lint issues
flutter analyze
```

### Android-specific

**Config**: `android/gradle.properties` tuned for single worker + 2048m heap.

## 8. Common Patterns & Conventions

### Feature Cubit Template

```dart
// Minimal cubit emitting 2 states: Loading → Loaded/Error
class FeatureCubit extends Cubit<FeatureState> {
  final FeatureRepository _repo;
  
  FeatureCubit(this._repo) : super(const FeatureInitial());
  
  Future<void> load() async {
    emit(const FeatureLoading());
    try {
      final data = await _repo.fetchData();
      emit(FeatureLoaded(data));
    } catch (e) {
      debugPrint('Error: $e');  // ⚠️ Note: uses debugPrint, not error state
      emit(FeatureLoaded([]));  // Emits empty state as fallback
    }
  }
}
```

**Pattern**: Cubits often catch exceptions and emit neutral/loading state instead of dedicated error state. Consider improving this with proper error handling.

### Repository Pattern

```dart
// Abstract repository (interface)
abstract class FeatureRepository {
  Future<List<Item>> fetchItems();
}

// Implementation (uses DataSource + Firestore)
class FeatureRepositoryImpl implements FeatureRepository {
  final FirestoreFeatureDataSource _dataSource;
  
  @override
  Future<List<Item>> fetchItems() async {
    return _dataSource.fetchItems();  // Delegates to data source
  }
}
```

### Data Source Pattern

```dart
class FirestoreFeatureDataSource {
  Stream<List<Item>> watchItems() {
    return _firestore
      .collection('items')
      .snapshots()
      .map((snapshot) => snapshot.docs.map(Item.fromSnapshot).toList());
  }
}
```

## 9. Potential Pitfalls & How to Avoid

| Pitfall | Why | Solution |
|---------|-----|----------|
| **Direct device state writes** | `Control` collection is command-only; read status from `device_states` | Use `DeviceRepository.sendCommand()` for writes, read from `device_states` streams |
| **Locale/Theme not persisting** | Must save to SharedPreferences in cubits | `ThemeCubit` and `LocaleCubit` already do this — don't bypass |
| **RTL breaks on new screens** | Mixing `EdgeInsets` (LTR) with `EdgeInsetsDirectional` (RTL) | Always use `EdgeInsetsDirectional`, `BorderRadiusDirectional`, `AlignmentDirectional` |
| **Streams leak memory** | No centralized unsubscribe; lazy singletons hold stream references | Dispose streams in cubits or use `.take(1)` for one-time fetches |
| **Double registration in DI** | GetIt throws if same type registered twice | Check `if (di.isRegistered<Type>()) return;` before each registration |
| **Missing i18n strings** | App crashes at runtime if string key doesn't exist | Test with both EN and AR locales; add all new strings to `app_localizations.dart` |
| **Responsive layout breaks** | `flutter_screenutil` (dps) vs manual responsive sizing conflict | Stick to one approach per widget; prefer `ScreenUtilInit` design size |
| **Tests missing for changes** | No test safety net → manual QA required | Document manual test steps in commit message; consider adding unit tests for critical paths |

## 10. Code Quality & Checks

### Static Analysis

```bash
flutter analyze
```

**Config**: Standard Flutter lints in `analysis_options.yaml`. Fix issues before submitting changes.

### Testing ⚠️

- **No automated tests** (only placeholder `test/widget_test.dart`)
- **No unit tests, integration tests, or widget tests**
- **Manual QA required** for all changes
- **Risk**: Breaking changes may not be caught

**Recommendation**: Add widget tests for new features in `test/` folder.

### Firebase Data Cleanup

To verify RTDB migration is complete:

```bash
grep -r "firebase_database" lib/   # expect 0 matches
grep -r "FirebaseDatabase" lib/    # expect 0 matches
```

---

## When You Need More Context

- **Architecture decisions & session history**: See [Waffar_App_Architecture.md](Waffar_App_Architecture.md)
- **Unified cubit implementation details**: Check `/memories/repo/unified_cubit_implementation.md`
- **Firestore schema & migration**: See [Waffar_App_Architecture.md — Section 2](Waffar_App_Architecture.md#2-firestore-database-architecture)
- **i18n coverage & RTL patterns**: See [Waffar_App_Architecture.md — Section 3](Waffar_App_Architecture.md#3-arabic-localization--rtl-support)

---

## Summary for AI Agents

✅ **Know before modifying code**:
1. Run tests first? → **No tests exist** (manual QA only)
2. Check DI? → Modify `lib/core/di/injection.dart` for new services
3. Add strings? → Update `lib/core/l10n/app_localizations.dart` (EN + AR)
4. Firestore changes? → Update repos + data sources; verify collection names
5. RTL-aware? → Always use `EdgeInsetsDirectional`, never `EdgeInsets.only(left:...)`
6. Device commands? → Write to `Control/`, read from `device_states/`

⚠️ **Common risks**:
- No error boundary states (catches errors, emits neutral state)
- Lazy singleton cubits may init late
- Stream disposal not centralized (memory leak risk)
- No test coverage → manual testing critical

🚀 **Build & deploy**:
- Dev: `flutter run`
- Web prod: `flutter build web`
- Check: `flutter analyze`

