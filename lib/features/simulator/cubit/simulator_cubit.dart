import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../devices/models/device_model.dart';
import 'simulator_states.dart';

class SimulatorCubit extends Cubit<SimulatorState> {
  SimulatorCubit() : super(SimulatorInitial());

  final _firestore = FirebaseFirestore.instance;
  final _random = Random();
  Timer? _updateTimer;

  // Simulation state
  final Map<String, _SimulatedDevice> _devices = {};
  bool _isRunning = false;

  void startSimulation() async {
    try {
      emit(SimulatorRunning(0));
      _isRunning = true;

      // Initialize all known devices
      _initializeDevices();

      // Start updates every 2 seconds
      _updateTimer?.cancel();
      _updateTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
        await _updateDeviceStates();
      });
    } catch (e) {
      emit(SimulatorError(e.toString()));
      _isRunning = false;
    }
  }

  void stopSimulation() async {
    try {
      _updateTimer?.cancel();
      _isRunning = false;
      
      // Turn off all devices on stop
      final batch = _firestore.batch();
      for (final deviceId in _devices.keys) {
        batch.update(
          _firestore.collection('device_states').doc(deviceId),
          {
            'status': 'OFF',
            'watts': 0.0,
            'amps': 0.0,
            'volts': 0.0,
            'kwh': 0.0,
            'last_updated': FieldValue.serverTimestamp(),
          },
        );
      }
      await batch.commit();

      emit(SimulatorStopped());
    } catch (e) {
      emit(SimulatorError(e.toString()));
    }
  }

  void _initializeDevices() {
    // All devices from the app
    const allDeviceIds = [
      'Lamp_LR_01', 'Fan_LR_01', 'TV_LR_01',
      'Lamp_BR_01', 'AC_BR_01',
      'Lamp_K_01', 'Fridge_K_01',
      'Lamp_B_01', 'HEATER_B_01',
      'Lamp_R2_01', 'AC_R2_01',
      'TV_BR_01', 'WASH_K_01',
    ];

    for (final id in allDeviceIds) {
      _devices[id] = _SimulatedDevice(
        id: id,
        baseVoltage: 220.0 + _random.nextDouble() * 10, // 220-230V
        baseAmperage: _getBaseAmperage(id),
      );
    }
  }

  Future<void> _updateDeviceStates() async {
    if (!_isRunning) return;

    try {
      final batch = _firestore.batch();
      int activeCount = 0;

      for (final device in _devices.values) {
        // 30% chance to toggle status every update
        if (_random.nextDouble() < 0.30) {
          device.isOn = !device.isOn;
        }

        // Calculate realistic values
        double voltage = device.baseVoltage + _random.nextDouble() * 4 - 2; // ±2V drift
        double amperage = 0.0;
        double watts = 0.0;

        if (device.isOn) {
          // Add realistic load variation
          amperage = device.baseAmperage * (0.8 + _random.nextDouble() * 0.4);
          watts = voltage * amperage;

          // Accumulate kWh (every 2 seconds = 1/1800 hour)
          device.kwhAccumulated += (watts / 1000.0) / 1800.0;
          activeCount++;
        }

        // Update Firestore
        batch.update(
          _firestore.collection('device_states').doc(device.id),
          {
            'status': device.isOn ? 'ON' : 'OFF',
            'watts': watts,
            'amps': amperage,
            'volts': voltage,
            'kwh': device.kwhAccumulated,
            'last_updated': FieldValue.serverTimestamp(),
          },
        );
      }

      await batch.commit();

      if (!isClosed) {
        emit(SimulatorRunning(activeCount));
      }
    } catch (e) {
      if (!isClosed) {
        emit(SimulatorError(e.toString()));
      }
    }
  }

  double _getBaseAmperage(String deviceId) {
    // Realistic amperage by device type
    final id = deviceId.toLowerCase();

    if (id.contains('lamp')) return 0.3; // LED bulb ~3W
    if (id.contains('fan')) return 0.7; // Fan ~150W
    if (id.contains('ac')) return 5.0; // Air conditioner ~1100W
    if (id.contains('tv')) return 0.8; // TV ~180W
    if (id.contains('fridge')) return 2.0; // Fridge ~440W
    if (id.contains('wash')) return 12.0; // Washer ~2640W
    if (id.contains('heater')) return 9.0; // Heater ~2000W

    return 1.0; // Default
  }

  @override
  Future<void> close() {
    _updateTimer?.cancel();
    return super.close();
  }
}

// Internal device simulation state
class _SimulatedDevice {
  _SimulatedDevice({
    required this.id,
    required this.baseVoltage,
    required this.baseAmperage,
  });

  final String id;
  final double baseVoltage;
  final double baseAmperage;

  bool isOn = false;
  double kwhAccumulated = 0.0;
}
