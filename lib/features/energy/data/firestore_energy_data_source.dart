import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../models/ai_result_model.dart';
import '../../energy/cubit/energy_states.dart';

/// Single access point for all Firestore energy/AI data reads.
/// Replaces the old RtdbDataSource — now Firestore-only.
class FirestoreEnergyDataSource {
  FirestoreEnergyDataSource() : _db = FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  // ── AI results (Firestore: ai_results/{simulator|hardware}) ──────────────

  /// Watch simulator AI results
  Stream<AIResultModel?> watchSimulator() => _db
      .collection(AppConstants.colAiResults)
      .doc(AppConstants.docSimulator)
      .snapshots()
      .map((snap) => _parseAiResult(snap));

  /// Watch hardware AI results
  Stream<AIResultModel?> watchHardware() => _db
      .collection(AppConstants.colAiResults)
      .doc(AppConstants.docHardware)
      .snapshots()
      .map((snap) => _parseAiResult(snap));

  /// Watch Real_Device_01 AI analysis
  Stream<AIResultModel?> watchRealDeviceAiResults() => _db
      .collection(AppConstants.colAiResults)
      .doc(AppConstants.docRealDevice)
      .snapshots()
      .map((snap) => _parseAiResult(snap));

  // ── Device state streams (Firestore: device_states) ─────────────────────

  /// Watch all device states from device_states collection
  Stream<List<EnergyRecord>> watchDeviceStates() => _db
      .collection(AppConstants.colDeviceStates)
      .snapshots()
      .map((snap) => _parseDeviceStates(snap));

  /// Watch a single device state
  Stream<EnergyRecord?> watchDeviceState(String deviceId) => _db
      .collection(AppConstants.colDeviceStates)
      .doc(deviceId)
      .snapshots()
      .map((snap) {
    if (!snap.exists || snap.data() == null) return null;
    return EnergyRecord.fromFirestore(deviceId, snap.data()!);
  });

  // ── One-shot reads ────────────────────────────────────────────────────────

  Future<AIResultModel?> readSimulatorOnce() =>
      watchSimulator().first;

  Future<AIResultModel?> readHardwareOnce() =>
      watchHardware().first;

  Future<AIResultModel?> readRealDeviceOnce() =>
      watchRealDeviceAiResults().first;

  Future<List<EnergyRecord>> readDeviceStatesOnce() =>
      watchDeviceStates().first;

  // ── Parsers ──────────────────────────────────────────────────────────────

  AIResultModel? _parseAiResult(DocumentSnapshot snap) {
    if (!snap.exists || snap.data() == null) return null;
    try {
      return AIResultModel.fromRtdb(
          Map<String, dynamic>.from(snap.data() as Map));
    } catch (_) {
      return null;
    }
  }

  List<EnergyRecord> _parseDeviceStates(QuerySnapshot snap) {
    try {
      return snap.docs
          .map((d) => EnergyRecord.fromFirestore(d.id, d.data() as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
