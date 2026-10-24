// ============================================================================
// ai_energy_repository.dart
// Single Firestore data source for all AI results and device energy data.
// Replaces AiResultsRepository + FirestoreEnergyDataSource (no duplication).
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/data/home_scope.dart';
import '../../../core/constants/app_constants.dart';
import '../models/energy_record.dart';

class AiEnergyRepository {
  AiEnergyRepository(this._scope);

  final HomeScope _scope;

  // ── AI result streams ─────────────────────────────────────────────────────

  /// Watch simulator AI results.
  Stream<Map<String, dynamic>?> watchSimulator() =>
      _watchAiDoc(AppConstants.docSimulator);

  /// Watch hardware (ESP32) AI results.
  Stream<Map<String, dynamic>?> watchHardware() =>
      _watchAiDoc(AppConstants.docHardware);

  /// Watch Real_Device_01 AI analysis.
  Stream<Map<String, dynamic>?> watchRealDevice() =>
      _watchAiDoc(AppConstants.docRealDevice);

  Stream<Map<String, dynamic>?> _watchAiDoc(String docId) => _scope
      .col(AppConstants.colAiResults)
      .doc(docId)
      .snapshots()
      .map((snap) => (snap.exists && snap.data() != null) ? snap.data() : null);

  // ── Device state streams ──────────────────────────────────────────────────

  /// Watch all device energy records from device_states collection.
  Stream<List<EnergyRecord>> watchDeviceStates() => _scope
      .col(AppConstants.colDeviceStates)
      .snapshots()
      .map(
        (snap) => snap.docs
            .map((d) => EnergyRecord.fromFirestore(d.id, d.data()))
            .toList(),
      );

  // ── Device control writes ─────────────────────────────────────────────────

  /// Send a command to Real_Device_01 (e.g. {'status': 'ON'}).
  Future<void> sendDeviceControl(Map<String, dynamic> command) => _scope
      .col(AppConstants.colDeviceControl)
      .doc(AppConstants.docRealDevice)
      .set(command, SetOptions(merge: true));
}
