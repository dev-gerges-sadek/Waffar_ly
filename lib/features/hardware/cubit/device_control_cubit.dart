import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../ai/data/ai_results_repository.dart';
import 'device_control_state.dart';

class DeviceControlCubit extends Cubit<DeviceControlState> {
  DeviceControlCubit() : super(DeviceControlInitial());

  final _repo = GetIt.I<AiResultsRepository>();

  Future<void> sendCommand(String command) async {
    emit(DeviceControlLoading());
    try {
      await _repo.sendDeviceControl({
        'command': command,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'device': 'Real_Device_01',
      });
      emit(DeviceControlSuccess(command: command));
      // Auto-reset after 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      if (!isClosed) emit(DeviceControlInitial());
    } catch (e) {
      emit(DeviceControlError(message: e.toString()));
      // Auto-reset after 4 seconds
      await Future.delayed(const Duration(seconds: 4));
      if (!isClosed) emit(DeviceControlInitial());
    }
  }
}
