import 'package:get_it/get_it.dart';
import 'package:waffar_ly_app/core/services/music_service.dart';
import 'package:waffar_ly_app/features/chatbot/data/chatbot_repository_impl.dart';
import 'package:waffar_ly_app/features/chatbot/domain/repositories/chatbot_repository.dart';
import 'package:waffar_ly_app/features/devices/data/combined_device_repository.dart';
import 'package:waffar_ly_app/features/devices/data/hardware_device_repository_impl.dart';
import 'package:waffar_ly_app/features/devices/data/simulation_device_repository_impl.dart';
import 'package:waffar_ly_app/features/devices/domain/repositories/device_repository.dart';

final GetIt di = GetIt.instance;

Future<void> setupDependencies() async {
  if (di.isRegistered<MusicService>()) return;

  di.registerLazySingleton<MusicService>(() => MusicService());
  di.registerLazySingleton<SimulationDeviceRepositoryImpl>(
      () => SimulationDeviceRepositoryImpl());
  di.registerLazySingleton<HardwareDeviceRepositoryImpl>(
      () => HardwareDeviceRepositoryImpl());
  di.registerLazySingleton<DeviceRepository>(
    () => CombinedDeviceRepository(
      simulationRepository: di<SimulationDeviceRepositoryImpl>(),
      hardwareRepository: di<HardwareDeviceRepositoryImpl>(),
    ),
  );
  di.registerLazySingleton<ChatbotRepository>(() => ChatbotRepositoryImpl());
}
