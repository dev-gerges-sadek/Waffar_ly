import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/hardware_repository.dart';
import '../models/hardware_device.dart';
import 'hardware_states.dart';

class HardwareCubit extends Cubit<HardwareState> {
  HardwareCubit(this._repo) : super(HardwareInitial());

  final HardwareRepository _repo;
  StreamSubscription<HardwareDevice?>? _sub;
  Timer? _watchdog;
  HwConnectionStatus _connStatus = HwConnectionStatus.disconnected;

  static const _staleAfter = Duration(seconds: 30);

  void startListening() {
    emit(HardwareLoading());
    _connStatus = HwConnectionStatus.reconnecting;

    _sub?.cancel();
    _sub = _repo.watchDevice().listen(
      (device) {
        _connStatus = HwConnectionStatus.connected;
        if (!isClosed) {
          emit(
            HardwareLoaded(
              devices: device == null ? const [] : [device],
              connectionStatus: _connStatus,
            ),
          );
        }
        _armWatchdog();
      },
      onError: (Object e, StackTrace st) {
        if (kDebugMode) debugPrint('[HardwareCubit] $e');
        _connStatus = HwConnectionStatus.disconnected;
        // Raw exception text is never shown to the user.
        if (!isClosed) emit(HardwareError('hardware_stream_error'));
      },
    );
  }

  /// If no update arrives within [_staleAfter] flag the link as reconnecting.
  void _armWatchdog() {
    _watchdog?.cancel();
    _watchdog = Timer(_staleAfter, () {
      _connStatus = HwConnectionStatus.reconnecting;
      final s = state;
      if (!isClosed && s is HardwareLoaded) {
        emit(
          HardwareLoaded(devices: s.devices, connectionStatus: _connStatus),
        );
      }
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _watchdog?.cancel();
    return super.close();
  }
}
