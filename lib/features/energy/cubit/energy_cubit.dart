import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import 'energy_states.dart';

// Room suffix map (duplicated here to avoid device_model circular dep)
const _kRoomSuffix = {
  'LR': 'Living Room',
  'BR': 'Bedroom',
  'K':  'Kitchen',
  'B':  'Bathroom',
  'R2': 'Room 2',
};

class EnergyCubit extends Cubit<EnergyState> {
  EnergyCubit() : super(EnergyInitial());

  final _firestore = FirebaseFirestore.instance;
  StreamSubscription? _sub;
  double _rate = 0.05;

  Future<void> loadEnergy() async {
    emit(EnergyLoading());
    final prefs = await SharedPreferences.getInstance();
    _rate = prefs.getDouble(AppConstants.keyElectricityRate) ?? 0.05;

    _sub?.cancel();
    _sub = _firestore
        .collection(AppConstants.colDeviceStates)
        .snapshots()
        .listen((snap) {
      final records = snap.docs
          .map((d) => EnergyRecord.fromFirestore(d.id, d.data()))
          .toList();

      if (records.isEmpty) {
        emit(EnergyLoaded(
          records: [], totalKwh: 0, estimatedCost: 0,
          topDevices: [], roomBreakdown: [], electricityRate: _rate,
        ));
        return;
      }

      final totalKwh = records.fold(0.0, (s, r) => s + r.kwh);
      final sorted   = [...records]..sort((a, b) => b.kwh.compareTo(a.kwh));
      final topDevices = sorted.take(5).toList();

      final roomMap = <String, double>{};
      for (final r in records) {
        final room = _roomFromId(r.deviceId);
        roomMap[room] = (roomMap[room] ?? 0) + r.kwh;
      }
      final roomBreakdown = roomMap.entries
          .map((e) => RoomEnergy(roomName: e.key, totalKwh: e.value))
          .toList()
        ..sort((a, b) => b.totalKwh.compareTo(a.totalKwh));

      emit(EnergyLoaded(
        records: records, totalKwh: totalKwh,
        estimatedCost: totalKwh * _rate, topDevices: topDevices,
        roomBreakdown: roomBreakdown, electricityRate: _rate,
      ));
    }, onError: (e) => emit(EnergyError(e.toString())));
  }

  Future<void> updateRate(double newRate) async {
    _rate = newRate;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.keyElectricityRate, newRate);
    if (state is EnergyLoaded) {
      final s = state as EnergyLoaded;
      emit(EnergyLoaded(
        records: s.records, totalKwh: s.totalKwh,
        estimatedCost: s.totalKwh * newRate, topDevices: s.topDevices,
        roomBreakdown: s.roomBreakdown, electricityRate: newRate,
      ));
    }
  }

  String _roomFromId(String id) {
    for (final e in _kRoomSuffix.entries) {
      if (id.contains('_${e.key}_')) return e.value;
    }
    return 'Other';
  }

  @override
  Future<void> close() { _sub?.cancel(); return super.close(); }
}
