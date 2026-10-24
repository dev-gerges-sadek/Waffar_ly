import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waffar_ly_app/features/devices/cubit/devices_cubit.dart';
import 'package:waffar_ly_app/features/devices/cubit/devices_states.dart';
import 'package:waffar_ly_app/features/devices/domain/repositories/device_repository.dart';
import 'package:waffar_ly_app/features/devices/models/device_model.dart';

class _MockRepo extends Mock implements DeviceRepository {}

class _FakeDevice extends Fake implements DeviceModel {}

DeviceModel _lamp({required bool on}) => DeviceModel(
  id: 'Lamp_LR_01',
  name: 'Lamp LR 01',
  type: DeviceType.lamp,
  roomId: 'living_room',
  simulationData: DeviceData(status: on ? 'ON' : 'OFF'),
);

void main() {
  setUpAll(() => registerFallbackValue(_FakeDevice()));

  late _MockRepo repo;
  late StreamController<List<DeviceModel>> ctrl;

  setUp(() {
    repo = _MockRepo();
    ctrl = StreamController<List<DeviceModel>>();
    when(() => repo.watchDevicesForRoom(any())).thenAnswer((_) => ctrl.stream);
  });
  tearDown(() => ctrl.close());

  test('failed toggle reverts and bumps toggleErrorSeq, staying Loaded', () async {
    when(() => repo.toggleDevice(any(), any())).thenThrow(Exception('net'));
    final cubit = DevicesCubit(repository: repo)
      ..loadDevicesForRoom('living_room');

    ctrl.add([_lamp(on: false)]);
    await Future<void>.delayed(Duration.zero);

    await cubit.toggleSimulation('Lamp_LR_01', true);

    final s = cubit.state as DevicesLoaded;
    expect(s.devices.single.isOn, isFalse, reason: 'optimistic change reverted');
    expect(s.toggleErrorSeq, 1);
    await cubit.close();
  });

  test('successful toggle keeps the optimistic value', () async {
    when(() => repo.toggleDevice(any(), any())).thenAnswer((_) async {});
    final cubit = DevicesCubit(repository: repo)
      ..loadDevicesForRoom('living_room');

    ctrl.add([_lamp(on: false)]);
    await Future<void>.delayed(Duration.zero);
    await cubit.toggleSimulation('Lamp_LR_01', true);

    final s = cubit.state as DevicesLoaded;
    expect(s.devices.single.isOn, isTrue);
    expect(s.toggleErrorSeq, 0);
    await cubit.close();
  });

  test('stream error becomes DevicesError (no raw message)', () async {
    final cubit = DevicesCubit(repository: repo)
      ..loadDevicesForRoom('living_room');
    ctrl.addError(Exception('permission-denied'));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isA<DevicesError>());
    await cubit.close();
  });
}
