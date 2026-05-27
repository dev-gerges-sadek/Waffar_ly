# Troubleshooting Guide

## 🔧 Common Issues & Solutions

---

## 1. Simulation Button Not Responding

### Symptoms:
- Button click doesn't update UI
- Changes appear after several seconds
- Sometimes reverts after click

### Solutions:

**A. Check DevicesCubit**
```bash
# Search for toggleSimulation method
grep -n "toggleSimulation" lib/features/devices/cubit/devices_cubit.dart

# Should have this pattern:
# 1. Update local _devices
# 2. Call _emitLoaded()
# 3. Await Firebase write
# 4. On error: revert + emit again
```

**B. Verify Firebase Connection**
```dart
// Check Firebase connection
FirebaseFirestore.instance.collection('test').doc('test').get()
  .then((_) => print('Firebase OK'))
  .catchError((e) => print('Firebase Error: $e'));
```

**C. Check Repository**
```bash
# Ensure toggleDevice is async
grep -n "toggleDevice" lib/features/devices/repositories/device_repository.dart

# Should return: Future<void>
```

---

## 2. Arabic Text Not Displaying

### Symptoms:
- Some text shows in English even in Arabic mode
- Text says "Hardware Monitor" instead of "مراقب الأجهزة"
- Numbers not formatted in Arabic

### Solutions:

**A. Verify Localization Setup**
```dart
// Check app_localizations.dart exists
// Verify isArabic property:
bool get isArabic => Localizations.localeOf(context).languageCode == 'ar';
```

**B. Find Hardcoded Strings**
```bash
# Search for hardcoded English in Flutter files
grep -r "Hardware Monitor" lib/
grep -r "Device Control" lib/
grep -r "AI Analysis" lib/

# Replace with: l10n.hardwareMonitor, l10n.deviceControl, etc.
```

**C. Check Locale Setup**
```dart
// In main.dart, verify supportedLocales:
supportedLocales: [
  Locale('en'),
  Locale('ar'),
],
```

---

## 3. Hardware UI Showing Data When Shouldn't

### Symptoms:
- Hardware badges show Watts/Amps/Voltage
- Device detail sheet shows hardware data
- User wants UI-only (no data display)

### Solutions:

**A. Verify Removals**
```bash
# Check device_card.dart - should not show hardware badge
grep -n "DeviceDataBadge" lib/features/devices/widgets/device_card.dart

# Check device_detail_sheet.dart - should not show hardware panel
grep -n "DeviceDataPanel.*hardware" lib/features/devices/widgets/device_detail_sheet.dart
```

**B. If Data Still Shows**
```dart
// device_card.dart should only show:
DeviceSimulationToggle() // ✅ This shows toggle only
// NOT:
DeviceDataBadge(simulationData: ..., hardwareData: ...) // ❌ Remove
```

---

## 4. Firebase Data Panel Not Showing

### Symptoms:
- Hardware Data Panel appears blank
- Shows "No data" message
- Connection error shown

### Solutions:

**A. Verify Collection Exists**
```bash
# Firebase Console → Firestore → ai_results
# Should have document: Real_Device_01
# With fields: watts, amperes, voltage, kwh_consumed, cost_so_far_egp, etc.
```

**B. Check Firestore Security Rules**
```
match /ai_results/{document=**} {
  allow read: if request.auth != null;
  allow write: if request.auth != null;
}
```

**C. Debug in Code**
```dart
// Add debug output
FirebaseFirestore.instance
  .collection('ai_results')
  .doc('Real_Device_01')
  .get()
  .then((doc) {
    print('Doc exists: ${doc.exists}');
    print('Data: ${doc.data()}');
  })
  .catchError((e) => print('Error: $e'));
```

---

## 5. Chatbot Messages Misaligned (RTL Issue)

### Symptoms:
- Arabic text appears left-aligned in messages
- Message bubbles not properly rounded
- Padding inconsistent in RTL mode

### Solutions:

**A. Verify RTL Padding Changes**
```bash
# Check for EdgeInsetsDirectional usage
grep -n "EdgeInsets" lib/features/chatbot/widgets/

# Should show EdgeInsetsDirectional for padding/margin
# NOT EdgeInsets
```

**B. Check Message Bubble**
```dart
// message_bubble.dart should use:
borderRadius: BorderRadius.only(
  topLeft: Radius.circular(16.r),
  topRight: Radius.circular(16.r),
  bottomStart: Radius.circular(...), // Not bottomLeft!
  bottomEnd: Radius.circular(...),   // Not bottomRight!
),
```

**C. Test RTL Manually**
```dart
// Wrap in Directionality widget
Directionality(
  textDirection: TextDirection.rtl,
  child: MessageBubble(...),
)
```

---

## 6. Unified Cubit Not Emitting Events

### Symptoms:
- Energy data not updating
- State stays in loading
- No data displayed on screens

### Solutions:

**A. Verify Cubit Started**
```dart
// In screen's initState or bloc provider:
UnifiedEnergyAiCubit cubit = context.read();
cubit.startListening(); // MUST call this!
```

**B. Check Firebase Subscriptions**
```dart
// In unified_energy_ai_cubit.dart
void startListening() {
  // Should see log output:
  // "Starting AI simulator subscription..."
  // "Starting energy state subscription..."
}
```

**C. Verify State Type**
```dart
// Screen expects EnergyLoaded state
BlocBuilder<UnifiedEnergyAiCubit, UnifiedEnergyState>(
  builder: (ctx, state) {
    if (state is EnergyLoaded) {
      // ✅ Correct
      return Text('${state.totalWatts}W');
    }
    return CircularProgressIndicator(); // ❌ Should see this briefly
  },
);
```

---

## 7. Performance Issues

### Symptoms:
- App feels slow/laggy
- Language toggle takes time
- Firebase updates freeze UI

### Solutions:

**A. Reduce Rebuilds**
```dart
// Use BlocSelector instead of BlocBuilder
BlocSelector<DevicesCubit, DevicesState, String>(
  selector: (state) => state.currentRoom,
  builder: (context, room) => Text(room),
)
```

**B. Optimize Firebase Queries**
```dart
// Instead of:
collection('ai_results').snapshots() // All docs

// Use:
collection('ai_results')
  .doc('Real_Device_01')
  .snapshots() // Single doc
```

**C. Enable Profiling**
```bash
flutter run --profile
# Check Performance tab in DevTools
```

---

## 8. Arabic Prompts Not Showing in Chatbot

### Symptoms:
- Suggested prompts always in English
- Even after language change
- Arabic prompts not available

### Solutions:

**A. Verify Prompt Translation**
```bash
# Check suggested_prompts_bar.dart
grep -n "_getPrompts" lib/features/chatbot/widgets/suggested_prompts_bar.dart

# Should have both English and Arabic arrays
```

**B. Check Locale Provider**
```dart
// Make sure AppLocalizations is accessible
final l10n = AppLocalizations.of(context);
bool isArabic = l10n.isArabic; // Should be true in Arabic mode
```

**C. Manually Trigger Rebuild**
```dart
// If prompts don't update on language change:
// 1. Restart app
// 2. Check LocaleCubit.toggleLocale()
// 3. Verify MaterialApp rebuilds with new locale
```

---

## 9. Code Duplication Still Present

### Symptoms:
- Old AiCubit still being used
- EnergyCubit still imported in screens
- UnifiedEnergyAiCubit not integrated

### Solutions:

**A. Find Old Cubits**
```bash
grep -r "AiCubit\|EnergyCubit" lib/
# Should return only in:
# - unified_energy_ai_cubit.dart (imports)
# - NEXT_STEPS.md (documentation)
```

**B. Replace Usage**
```dart
// OLD
BlocProvider(create: (_) => AiCubit()),
BlocProvider(create: (_) => EnergyCubit()),

// NEW
BlocProvider(create: (_) => UnifiedEnergyAiCubit(aiRepo)..startListening()),
```

**C. Update State Handling**
```dart
// OLD
BlocBuilder<AiCubit, AiState>(...)
BlocBuilder<EnergyCubit, EnergyState>(...)

// NEW
BlocBuilder<UnifiedEnergyAiCubit, UnifiedEnergyState>(...)
```

---

## 10. Firebase Authentication Issues

### Symptoms:
- Can't access Firebase collections
- Permission denied errors
- Data not syncing

### Solutions:

**A. Verify Authentication**
```dart
// Check if user is logged in
FirebaseAuth.instance.authStateChanges().listen((user) {
  print('User: ${user?.email}');
  if (user == null) print('Not authenticated!');
});
```

**B. Check Firestore Rules**
```bash
# Firebase Console → Firestore → Rules
# Should allow authenticated users:
match /{document=**} {
  allow read, write: if request.auth != null;
}
```

**C. Test Connection**
```bash
# Run this in console to test:
# Firebase Console → Firestore → Web Preview
# Try to read/write a test document
```

---

## 🆘 Still Not Working?

### Debug Steps:

1. **Enable Debug Logging**
```dart
// In main.dart
firebase_core: {debug: true}
```

2. **Check Console Output**
```bash
flutter logs
```

3. **Use DevTools**
```bash
flutter pub global activate devtools
devtools
```

4. **Check File Modifications**
```bash
git diff lib/  # See what changed
git status    # Check for conflicts
```

5. **Clean Build**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📞 Need More Help?

If issue persists:
1. Check FIXES_SUMMARY_AR.md for overview
2. Review TESTING_CHECKLIST.md for expected behavior
3. Check NEXT_STEPS.md for integration steps
4. Review this Troubleshooting Guide
5. Enable all debug logging and check console

---

**Last Updated**: After all fixes applied
**Status**: Ready for debugging
