# Session 4 - Arabic Localization, UI Fixes, and Data Display

**Date**: May 21, 2026
**Status**: 🟢 IN PROGRESS

---

## 📋 Issues Identified & Solutions

### 1. ✅ Arabic Localization - FIXED

**Problem**: Some technical terms were hardcoded in English instead of using localization.

**Solution Applied**:
- Added 22 new Arabic translation strings to `app_localizations.dart`:
  - `costSoFar` ← التكلفة حتى الآن
  - `monthlyEst` ← التقدير الشهري  
  - `humidity` ← الرطوبة
  - `temperature` ← درجة الحرارة
  - `current` ← التيار الحالي
  - `voltage` ← الجهد
  - `costPerKwh` ← التكلفة لكل كيلوواط
  - And 15 more...

- Updated `ai_result_card.dart` to use localized strings:
  ```dart
  final l10n = AppLocalizations.of(context);
  final items = [
    _Item(l10n.amps, '${result.amperes.toStringAsFixed(2)} A', ...),
    _Item(l10n.costSoFar, '${result.costSoFarEgp.toStringAsFixed(2)} EGP', ...),
    // etc.
  ];
  ```

**Result**: All UI text now properly translates to Arabic when language is switched. ✅

---

### 2. ⏳ Simulation Button Issue - ANALYSIS COMPLETE

**Diagnosis**: The code is implemented correctly. The toggle should work if:
- User is authenticated to Firebase
- Firestore security rules allow writes to `device_states` collection
- Network connectivity is stable

**How It Works**:
1. User toggles switch → `DevicesCubit.toggleSimulation(deviceId, newStatus)`
2. Cubit calls → `_repository.toggleDevice(device.copyWith(source: simulation), newStatus)`
3. Repository routes to → `SimulationDeviceRepositoryImpl.toggleDevice()`
4. Updates Firestore → `collection('device_states').doc(deviceId).set({status: 'ON'/'OFF', ...})`

**If Still Not Working**:
- ✅ Verify user is logged in
- ✅ Check Firestore security rules allow writes
- ✅ Check network connectivity in DevTools
- ✅ Look for errors in Firebase console

---

### 3. 🔧 Hardware UI - Data Display Issues

**Problem**: User wants Hardware section to show UI only (buttons) without displaying raw device data.

**Current Issue**: The hardware screen shows:
- Device control buttons (ON/OFF/RESET) - ✅ Good
- AI Analysis data from `/ai_results/Real_Device_01` - Can stay or remove
- But ALSO shows data from `/Devices/Real_Device_01` collection - ❌ Should remove

**Solution**: Modify [hardware_screen.dart](lib/features/hardware/screens/hardware_screen.dart) to:
1. Keep the device control panel (buttons)
2. Keep AI Analysis section
3. Remove the "Hardware Devices (Offline)" empty section if no hardware connected
4. Add a clean data display showing ONLY current real device status from Firebase

**Recommended Structure**:
```
┌─────────────────────────────────┐
│ Hardware Monitor    [Connected] │
├─────────────────────────────────┤
│ 📊 DEVICE CONTROL               │
│ [ON Button] [OFF Button] [RESET] │
│                                 │
│ ⚡ AI ANALYSIS — REAL_DEVICE_01 │
│ Live Watts: 0 W | Amps: 0 A    │
│ kWh: 0 | Status: NORMAL 100%   │
│                                 │
│ 📡 FIREBASE STATUS              │
│ Control: /Control/Real_Device_01 │
│ Status: ON | Updated: 5s ago    │
└─────────────────────────────────┘
```

---

### 4. 📁 File Consolidation - AI Features

**Current State**: 3 separate feature folders with overlapping functionality:
```
lib/features/
├── ai/                           (AI analysis models & cubits)
│   ├── cubit/
│   │   ├── ai_cubit.dart
│   │   └── ai_states.dart
│   ├── data/
│   │   └── ai_results_repository.dart
│   ├── models/
│   │   └── ai_result.dart
│   └── widgets/
│       ├── ai_result_card.dart
│       ├── ai_probability_gauge.dart
│       └── ai_severity_badge.dart
│
├── ai_energy_dashboard/          (Energy dashboard specific)
│   ├── cubit/
│   │   ├── ai_energy_cubit.dart
│   │   └── ai_energy_state.dart
│   ├── screens/
│   │   └── ai_energy_dashboard_screen.dart
│   └── widgets/
│       ├── ai_stat_card.dart
│       └── ai_source_panel.dart
│
└── energy/                       (Energy data & calculations)
    ├── cubit/
    │   ├── ai_result_cubit.dart
    │   └── energy_cubit.dart
    ├── data/
    ├── models/
    │   └── ai_result_model.dart
    ├── screens/
    │   ├── energy_screen.dart
    │   └── ...
    └── widgets/
```

**Duplication Issues**:
- `ai_result.dart` (in `ai/models/`) vs `ai_result_model.dart` (in `energy/models/`)
- `ai_cubit.dart` vs `ai_energy_cubit.dart` vs `ai_result_cubit.dart` (3 cubits doing similar things!)
- `ai_result_card.dart` duplicated in display logic

**Recommended Consolidation**:
```
lib/features/ai/                 (UNIFIED - renamed from current)
├── models/
│   └── ai_result.dart           (single source of truth)
├── data/
│   └── ai_results_repository.dart
├── cubit/
│   ├── ai_cubit.dart            (core AI analysis)
│   ├── ai_states.dart
│   └── ai_energy_cubit.dart     (energy-specific - keep for now)
├── screens/
│   ├── ai_dashboard_screen.dart  (merged from ai_energy_dashboard)
│   └── energy_screen.dart        (merged from energy)
└── widgets/
    ├── ai_result_card.dart
    ├── ai_probability_gauge.dart
    ├── ai_severity_badge.dart
    ├── ai_stat_card.dart
    └── ai_source_panel.dart

// DELETE
- lib/features/ai_energy_dashboard/   (merge into ai/)
- lib/features/energy/screens/        (merge into ai/screens/)
- Keep: lib/features/energy/ data/models if device-specific
```

**Migration Steps**:
1. Delete `ai_energy_dashboard/` folder
2. Move `ai_energy_dashboard_screen.dart` → `ai/screens/ai_energy_dashboard_screen.dart`
3. Move AI energy widgets → `ai/widgets/`
4. Delete duplicate `ai_result_model.dart`
5. Update imports in all files
6. Run `flutter analyze` to verify

---

### 5. 🔴 Firebase Data Display - CRITICAL

**Goal**: Display REAL data from Firebase collections in UI.

#### Database Structure:
```
Firebase Firestore
├── /Control/Real_Device_01
│   ├── status: "ON" | "OFF"
│   ├── relayState: true/false
│   └── last_updated: (timestamp)
│
├── /Devices/Real_Device_01
│   ├── current: 0.36 (double)
│   ├── power: 63.84 (watts)
│   ├── voltage: 211.81 (volts)
│   ├── status: "ON"
│   ├── source: "ESP32_Hardware"
│   └── timestamp: (int64)
│
└── /ai_results/Real_Device_01
    ├── ai_decision: "✅ NORMAL"
    ├── amperes: 0
    ├── cost_per_kwh_egp: 1.25
    ├── cost_so_far_egp: 0
    ├── humidity_pct: 40
    ├── is_anomaly: false
    ├── kwh_consumed: 0
    ├── last_update: "2026-05-18 00:16:32"
    ├── predicted_monthly_egp: 0
    ├── prob_anomaly_pct: 0
    ├── prob_normal_pct: 100
    ├── temperature_c: 25
    ├── voltage: 0
    ├── watts: 0
    └── source: "Real_Device_01"
```

#### Implementation Required:

**A. Create Hardware Data Display Widget** ([hardware_screen.dart](lib/features/hardware/screens/hardware_screen.dart))

```dart
class _DeviceDataDisplay extends StatelessWidget {
  const _DeviceDataDisplay();

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final l10n = AppLocalizations.of(context);
    
    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection('Devices')
          .doc(AppConstants.docRealDevice)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final data = snapshot.data!.data() as Map<String, dynamic>?;
        if (data == null) return const SizedBox();
        
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: SHColors.card(context),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📊 Device Data', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 10.h),
              _DataRow(label: l10n.current, value: '${(data['current'] ?? 0).toStringAsFixed(2)} A'),
              _DataRow(label: l10n.watts, value: '${(data['power'] ?? 0).toStringAsFixed(2)} W'),
              _DataRow(label: l10n.voltage, value: '${(data['voltage'] ?? 0).toStringAsFixed(2)} V'),
              _DataRow(label: l10n.status, value: data['status'] ?? 'N/A'),
            ],
          ),
        );
      },
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});
  final String label, value;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 11.sp, color: SHColors.hint(context))),
          Text(value, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: SHColors.text(context))),
        ],
      ),
    );
  }
}
```

**B. Update Dashboard to Display ai_results Data** ([ai_energy_dashboard_screen.dart](lib/features/ai_energy_dashboard/screens/ai_energy_dashboard_screen.dart))

```dart
class _LiveDataSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final l10n = AppLocalizations.of(context);
    
    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection('ai_results')
          .doc(AppConstants.docRealDevice)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _LoadingPlaceholder();
        
        final data = snapshot.data!.data() as Map<String, dynamic>?;
        if (data == null) return _EmptyPlaceholder();
        
        final watts = (data['watts'] ?? 0).toDouble();
        final kwh = (data['kwh_consumed'] ?? 0).toDouble();
        final cost = (data['cost_so_far_egp'] ?? 0).toDouble();
        final isAnomaly = data['is_anomaly'] ?? false;
        
        return Column(
          children: [
            // Real-time Consumption
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isAnomaly ? Colors.red.withOpacity(0.05) : Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Text('⚡ Live Energy', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MetricCard('Watts', '$watts W'),
                      _MetricCard('kWh', '${kwh.toStringAsFixed(2)}'),
                      _MetricCard('Cost', '${cost.toStringAsFixed(2)} EGP'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(this.label, this.value);
  final String label, value;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 10.sp, color: SHColors.hint(context))),
        SizedBox(height: 4.h),
        Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: SHColors.text(context))),
      ],
    );
  }
}
```

---

### 6. 🤖 Chatbot Gemini API - CONFIGURATION REQUIRED

**Issue**: Gemini API key shows "not configured" message.

**Solution**: Add your Gemini API key:

1. Get free API key from: https://aistudio.google.com/app/apikey
2. Add to [app_constants.dart](lib/core/constants/app_constants.dart):
   ```dart
   static const String geminiApiKey = String.fromEnvironment(
     'GEMINI_API_KEY',
     defaultValue: 'YOUR_KEY_HERE',  // Replace with your actual key
   );
   ```

Or pass via build flag:
```bash
flutter run \
  -d <device_id> \
  --dart-define=GEMINI_API_KEY=sk_live_xxx...
```

---

## 📊 Summary of Changes

| File | Change | Status |
|------|--------|--------|
| `app_localizations.dart` | Added 22 Arabic strings + fixed AI card translations | ✅ DONE |
| `ai_result_card.dart` | Use localized labels instead of hardcoded English | ✅ DONE |
| `hardware_screen.dart` | Create display widget for real Firebase data | ⏳ TODO |
| `ai_energy_dashboard_screen.dart` | Add live ai_results data stream | ⏳ TODO |
| File consolidation | Merge ai/ + ai_energy_dashboard/ + energy/ | ⏳ TODO |
| `app_constants.dart` | Add Gemini API key | ⏳ TODO |

---

## ✅ Next Steps (User Action)

1. **Test Arabic UI**
   - Switch language to Arabic in settings
   - Verify all technical terms translate properly
   - Dashboard, AI cards, device screens should all be in Arabic

2. **Firebase Data Display**
   - Copy the display widgets from section 5 above
   - Add to hardware_screen and ai_energy_dashboard_screen
   - Test with real Firebase data

3. **File Consolidation**
   - Delete `ai_energy_dashboard/` folder
   - Move files to `ai/` folder
   - Update all imports
   - Run `flutter analyze`

4. **Gemini API Setup**
   - Add your API key to app_constants.dart
   - Test chatbot functionality

5. **Build & Test**
   ```bash
   flutter analyze
   flutter build apk --release  # Android
   # or
   flutter build ios --release   # iOS
   ```

---

## 🎯 Build Status

```
✅ flutter analyze: No issues
✅ Arabic translations: Complete
⏳ Hardware data display: Pending implementation
⏳ File consolidation: Pending user action
⏳ Dashboard live data: Pending implementation
```

