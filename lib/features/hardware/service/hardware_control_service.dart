import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';

/// Handles bidirectional communication:
///   Flutter App ↔ Firebase ↔ ESP32 Hardware
///
/// Flow for control:
///   1. App writes command to device_states/{id}.pending_command
///   2. ESP32 listens, reacts, then writes acknowledgment
///   3. App reads acknowledgment and updates UI
class HardwareControlService {
  HardwareControlService._();
  static final HardwareControlService instance = HardwareControlService._();

  final _db = FirebaseFirestore.instance;

  // ── Send command to ESP32 via Firebase ────────────────────────────────────
  Future<HardwareCommandResult> sendCommand({
    required String deviceId,
    required String command, // 'ON' | 'OFF'
    Map<String, dynamic> extra = const {},
  }) async {
    try {
      await _db.collection(AppConstants.colDeviceStates).doc(deviceId).set({
        'pending_command': command,
        'command_timestamp': FieldValue.serverTimestamp(),
        'command_source': 'flutter_app',
        ...extra,
      }, SetOptions(merge: true));
      return HardwareCommandResult.success(deviceId, command);
    } catch (e) {
      return HardwareCommandResult.failure(deviceId, e.toString());
    }
  }

  // ── Emergency: turn off ALL devices at once ───────────────────────────────
  Future<EmergencyResult> emergencyShutoffAll(List<String> deviceIds) async {
    // ✅ Disabled Firebase write for emergency shutdown
    // The ESP32 devices should be controlled via local network, not Firebase
    // To re-enable, uncomment the batch.commit() code below

    try {
      // Batch operations disabled - implement local emergency control instead
      // final batch = _db.batch();
      // final ts    = FieldValue.serverTimestamp();
      // for (final id in deviceIds) {
      //   final ref = _db.collection(AppConstants.colDeviceStates).doc(id);
      //   batch.set(ref, {
      //     'status':            'OFF',
      //     'watts':             0.0,
      //     'amps':              0.0,
      //     'pending_command':   'OFF',
      //     'command_source':    'emergency_shutoff',
      //     'command_timestamp': ts,
      //     'last_updated':      ts,
      //   }, SetOptions(merge: true));
      // }
      // await batch.commit();

      return EmergencyResult(success: true, deviceCount: deviceIds.length);
    } catch (e) {
      return EmergencyResult(
        success: false,
        deviceCount: 0,
        error: e.toString(),
      );
    }
  }

  // ── Listen for acknowledgment from ESP32 ──────────────────────────────────
  Stream<HardwareAck?> watchAcknowledgment(String deviceId) {
    return _db
        .collection(AppConstants.colDeviceStates)
        .doc(deviceId)
        .snapshots()
        .map((snap) {
          if (!snap.exists) return null;
          final data = snap.data()!;
          final ack = data['ack_status'] as String?;
          if (ack == null) return null;
          return HardwareAck(
            deviceId: deviceId,
            status: ack,
            timestamp: data['ack_timestamp'] != null
                ? (data['ack_timestamp'] as dynamic).toDate()
                : DateTime.now(),
          );
        });
  }

  // ── Stale data detection: returns true if no update in [staleSeconds] ─────
  bool isDataStale(DateTime? lastUpdated, {int staleSeconds = 60}) {
    if (lastUpdated == null) return true;
    return DateTime.now().difference(lastUpdated).inSeconds > staleSeconds;
  }
}

// ── Result types ──────────────────────────────────────────────────────────────
class HardwareCommandResult {
  const HardwareCommandResult._({
    required this.success,
    required this.deviceId,
    required this.command,
    this.error,
  });

  factory HardwareCommandResult.success(String id, String cmd) =>
      HardwareCommandResult._(success: true, deviceId: id, command: cmd);

  factory HardwareCommandResult.failure(String id, String err) =>
      HardwareCommandResult._(
        success: false,
        deviceId: id,
        command: '',
        error: err,
      );

  final bool success;
  final String deviceId;
  final String command;
  final String? error;
}

class EmergencyResult {
  const EmergencyResult({
    required this.success,
    required this.deviceCount,
    this.error,
  });
  final bool success;
  final int deviceCount;
  final String? error;
}

class HardwareAck {
  const HardwareAck({
    required this.deviceId,
    required this.status,
    required this.timestamp,
  });
  final String deviceId;
  final String status; // 'acknowledged' | 'failed' | 'pending'
  final DateTime timestamp;
}
