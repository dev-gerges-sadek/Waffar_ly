import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/emergency_repository.dart';
import 'emergency_state.dart';

class EmergencyCubit extends Cubit<EmergencyState> {
  EmergencyCubit() : _repo = EmergencyRepository(), super(EmergencyIdle());

  final EmergencyRepository _repo;

  Future<void> shutoffAll() async {
    emit(EmergencyRunning());
    try {
      final count = await _repo.shutoffAllDevices();
      emit(EmergencyDone(count));
      Future.delayed(const Duration(seconds: 3), () {
        if (!isClosed) emit(EmergencyIdle());
      });
    } on FirebaseException catch (e) {
      emit(EmergencyError('Emergency shutdown failed: ${e.message ?? e.code}'));
      Future.delayed(const Duration(seconds: 3), () {
        if (!isClosed) emit(EmergencyIdle());
      });
    } catch (e) {
      emit(EmergencyError('Emergency shutdown failed: $e'));
      Future.delayed(const Duration(seconds: 3), () {
        if (!isClosed) emit(EmergencyIdle());
      });
    }
  }
}
