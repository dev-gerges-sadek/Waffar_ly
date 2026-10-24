import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/emergency_repository.dart';
import 'emergency_state.dart';

class EmergencyCubit extends Cubit<EmergencyState> {
  EmergencyCubit(this._repo) : super(EmergencyIdle());

  final EmergencyRepository _repo;
  Timer? _resetTimer;

  Future<void> shutoffAll() async {
    if (state is EmergencyRunning) return;
    emit(EmergencyRunning());
    try {
      final r = await _repo.shutoffAllDevices();
      if (isClosed) return;
      emit(EmergencyDone(r.simulationOff, hardwareSent: r.hardwareSent));
    } catch (e) {
      if (kDebugMode) debugPrint('[EmergencyCubit] $e');
      if (isClosed) return;
      emit(EmergencyError());
    }
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 3), () {
      if (!isClosed) emit(EmergencyIdle());
    });
  }

  @override
  Future<void> close() {
    _resetTimer?.cancel();
    return super.close();
  }
}
