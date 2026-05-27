import '../cubit/simulator_cubit.dart';

sealed class SimulatorState {}

class SimulatorInitial extends SimulatorState {}

class SimulatorRunning extends SimulatorState {
  SimulatorRunning(this.activeDevices);
  final int activeDevices;
}

class SimulatorStopped extends SimulatorState {}

class SimulatorError extends SimulatorState {
  SimulatorError(this.message);
  final String message;
}
