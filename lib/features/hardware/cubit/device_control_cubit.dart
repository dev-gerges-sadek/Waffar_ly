import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'device_control_state.dart';

/// Controls the relay state of `Real_Device_01` via Firestore.
///
/// Firestore path: `Control/Real_Device_01`
/// Fields written/read:
///   - `relayState`    (bool)   — the actual relay toggle value
///   - `last_updated`  (Timestamp) — server timestamp
///   - `device`        (String) — always "Real_Device_01"
///
/// The cubit streams the current `relayState` on creation so the UI
/// always reflects the real hardware state, not a local assumption.
class DeviceControlCubit extends Cubit<DeviceControlState> {
  DeviceControlCubit() : super(DeviceControlInitial()) {
    _subscribeToRelayState();
  }

  static const _collection = 'Control';
  static const _document   = 'Real_Device_01';

  final _db = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _sub;

  // ── Stream current relay state from Firestore on init ────────────────────

  void _subscribeToRelayState() {
    _sub = _db
        .collection(_collection)
        .doc(_document)
        .snapshots()
        .listen((snap) {
      if (!snap.exists) return;
      final data  = snap.data();
      if (data == null) return;
      final relay = data['relayState'] as bool? ?? false;
      // Only emit if state differs from current — avoids redundant rebuilds
      final current = state;
      if (current is RelayToggleSuccess && current.relayState == relay) return;
      if (!isClosed) {
        emit(RelayToggleSuccess(relayState: relay, fromFirestore: true));
      }
    }, onError: (e) {
      if (!isClosed) emit(DeviceControlError(message: e.toString()));
    });
  }

  // ── Toggle relay — writes to Firestore → ESP32 picks up the change ───────

  Future<void> toggleRelayState(bool newState) async {
    if (isClosed) return;
    emit(DeviceControlLoading());

    try {
      await _db
          .collection(_collection)
          .doc(_document)
          .set({
        'relayState':   newState,
        'last_updated': FieldValue.serverTimestamp(),
        'device':       _document,
      }, SetOptions(merge: true));

      // Optimistic emit — Firestore stream will confirm with fromFirestore: true
      if (!isClosed) {
        emit(RelayToggleSuccess(relayState: newState, fromFirestore: false));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DeviceControlError(message: e.toString()));
        // Auto-reset to initial after 4 s so UI is not stuck on error
        await Future.delayed(const Duration(seconds: 4));
        if (!isClosed) emit(DeviceControlInitial());
      }
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
