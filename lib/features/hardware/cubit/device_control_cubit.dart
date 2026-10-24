import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/hardware_repository.dart';
import 'device_control_state.dart';

/// Controls the relay of `Real_Device_01`.
///
/// The cubit streams the current `relayState` on creation so the UI reflects
/// the real hardware state, not a local assumption.
class DeviceControlCubit extends Cubit<DeviceControlState> {
  DeviceControlCubit(this._repo) : super(DeviceControlInitial()) {
    _sub = _repo.watchRelayState().listen(
      (relay) {
        if (relay == null || isClosed) return;
        final current = state;
        if (current is RelayToggleSuccess && current.relayState == relay) {
          return;
        }
        emit(RelayToggleSuccess(relayState: relay, fromFirestore: true));
      },
      onError: (Object e) {
        if (kDebugMode) debugPrint('[DeviceControlCubit] $e');
        if (!isClosed) emit(DeviceControlError(message: 'relay_stream_error'));
      },
    );
  }

  final HardwareRepository _repo;
  late final StreamSubscription<bool?> _sub;
  Timer? _resetTimer;

  Future<void> toggleRelayState(bool newState) async {
    if (isClosed) return;
    emit(DeviceControlLoading());
    try {
      await _repo.setRelay(newState);
      // Optimistic emit — the stream confirms with fromFirestore: true.
      if (!isClosed) {
        emit(RelayToggleSuccess(relayState: newState, fromFirestore: false));
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[DeviceControlCubit] toggle failed: $e');
      if (isClosed) return;
      emit(DeviceControlError(message: 'relay_toggle_error'));
      _resetTimer?.cancel();
      _resetTimer = Timer(const Duration(seconds: 4), () {
        if (!isClosed) emit(DeviceControlInitial());
      });
    }
  }

  @override
  Future<void> close() {
    _sub.cancel();
    _resetTimer?.cancel();
    return super.close();
  }
}
