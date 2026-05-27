import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared/domain/entities/music_info.dart';
import '../../../core/shared/domain/entities/smart_device.dart';
import '../../../core/shared/domain/entities/smart_room.dart';

/// All Firestore writes for smart room controls.
/// Also serves as the single source of SmartRoom instances.
class SmartRoomRepository {
  SmartRoomRepository() : _db = FirebaseFirestore.instance;
  final FirebaseFirestore _db;

  // ── Room list (built from static registry — no Firestore collection) ───────

  /// Returns the canonical room list built from [RoomRegistry].
  /// Marked Future to allow easy migration to a real Firestore collection later.
  Future<List<SmartRoom>> getRooms() async {
    return RoomRegistry.rooms.map((r) => SmartRoom(
      id:           r['id']!,
      name:         r['name']!,
      imageUrl:     r['image']!,
      temperature:  0,
      airHumidity:  0,
      lights:       SmartDevice(isOn: false, value: 0),
      airCondition: SmartDevice(isOn: false, value: 20),
      timer:        SmartDevice(isOn: false, value: 0),
      musicInfo:    MusicInfo(isOn: false, currentSong: Song.defaultSong),
    )).toList();
  }

  // ── AC ─────────────────────────────────────────────────────────────────────

  Future<void> updateAc({
    required int    roomId,
    required bool   isOn,
    required int    temperature,
    required String mode,
    required int    fanSpeed,
  }) async {
    await _db.collection(AppConstants.colDeviceStates)
        .doc('AC_BR_0$roomId')
        .set({
          'status':       isOn ? 'ON' : 'OFF',
          'temperature':  temperature,
          'mode':         mode,
          'fan_speed':    fanSpeed,
          'last_updated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  // ── Lights ─────────────────────────────────────────────────────────────────

  Future<void> updateLight({
    required String deviceId,
    required bool   isOn,
    double?         intensity,
  }) async {
    await _db.collection(AppConstants.colDeviceStates).doc(deviceId).set({
      'status':       isOn ? 'ON' : 'OFF',
      'intensity': ?intensity,
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ── Generic device toggle ──────────────────────────────────────────────────

  Future<void> toggleDevice(String deviceId, bool isOn) async {
    await _db.collection(AppConstants.colDeviceStates).doc(deviceId).set({
      'status':       isOn ? 'ON' : 'OFF',
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
