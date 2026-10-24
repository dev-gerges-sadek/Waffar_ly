import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waffar_ly_app/features/emergency/cubit/emergency_cubit.dart';
import 'package:waffar_ly_app/features/emergency/cubit/emergency_state.dart';
import 'package:waffar_ly_app/features/emergency/data/emergency_repository.dart';

class _MockRepo extends Mock implements EmergencyRepository {}

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  blocTest<EmergencyCubit, EmergencyState>(
    'full success reports hardwareSent = true',
    build: () {
      when(() => repo.shutoffAllDevices()).thenAnswer(
        (_) async =>
            const EmergencyOutcome(simulationOff: 3, hardwareSent: true),
      );
      return EmergencyCubit(repo);
    },
    act: (c) => c.shutoffAll(),
    expect: () => [
      isA<EmergencyRunning>(),
      isA<EmergencyDone>()
          .having((s) => s.turnedOffCount, 'count', 3)
          .having((s) => s.hardwareSent, 'hardwareSent', true),
    ],
  );

  blocTest<EmergencyCubit, EmergencyState>(
    'hardware failure is NOT reported as success',
    build: () {
      when(() => repo.shutoffAllDevices()).thenAnswer(
        (_) async =>
            const EmergencyOutcome(simulationOff: 2, hardwareSent: false),
      );
      return EmergencyCubit(repo);
    },
    act: (c) => c.shutoffAll(),
    expect: () => [
      isA<EmergencyRunning>(),
      isA<EmergencyDone>().having((s) => s.hardwareSent, 'hardwareSent', false),
    ],
  );

  blocTest<EmergencyCubit, EmergencyState>(
    'total failure emits EmergencyError (no raw exception text)',
    build: () {
      when(() => repo.shutoffAllDevices()).thenThrow(Exception('boom'));
      return EmergencyCubit(repo);
    },
    act: (c) => c.shutoffAll(),
    expect: () => [isA<EmergencyRunning>(), isA<EmergencyError>()],
  );
}
