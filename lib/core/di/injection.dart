import 'package:get_it/get_it.dart';
import '../../features/alert/data/repositories/anomaly_repository.dart';
import '../../features/chatbot/data/chatbot_repository_impl.dart';
import '../../features/chatbot/domain/repositories/chatbot_repository.dart';
import '../../features/devices/data/combined_device_repository.dart';
import '../../features/devices/data/hardware_device_repository_impl.dart';
import '../../features/devices/data/simulation_device_repository_impl.dart';
import '../../features/devices/domain/repositories/device_repository.dart';
import '../../features/emergency/data/emergency_repository.dart';
import '../../features/smart_room/cubit/smart_room_cubit.dart';
import '../../features/smart_room/data/smart_room_repository.dart';
import '../../features/ai_dashboard/data/ai_energy_repository.dart';
import '../../features/ai_dashboard/cubit/ai_energy_cubit.dart';
import '../services/music_service.dart';

final GetIt di = GetIt.instance;

Future<void> setupDependencies() async {
  if (di.isRegistered<MusicService>()) return;

  // ── Services ──────────────────────────────────────────────────────────────
  di.registerLazySingleton<MusicService>(() => MusicService());

  // ── Repositories ──────────────────────────────────────────────────────────
  di.registerLazySingleton<AiEnergyRepository>(() => AiEnergyRepository());
  di.registerLazySingleton<SmartRoomRepository>(() => SmartRoomRepository());
  di.registerFactory<SmartRoomCubit>(
    () => SmartRoomCubit(di<SmartRoomRepository>()),
  );
  di.registerLazySingleton<EmergencyRepository>(() => EmergencyRepository());
  di.registerLazySingleton<AnomalyRepository>(() => AnomalyRepository());
  di.registerLazySingleton<ChatbotRepository>(() => ChatbotRepositoryImpl());

  di.registerLazySingleton<SimulationDeviceRepositoryImpl>(
    () => SimulationDeviceRepositoryImpl(),
  );
  di.registerLazySingleton<HardwareDeviceRepositoryImpl>(
    () => HardwareDeviceRepositoryImpl(),
  );
  di.registerLazySingleton<DeviceRepository>(
    () => CombinedDeviceRepository(
      simulationRepository: di<SimulationDeviceRepositoryImpl>(),
      hardwareRepository: di<HardwareDeviceRepositoryImpl>(),
    ),
  );

  // ── Cubits ────────────────────────────────────────────────────────────────
  di.registerLazySingleton<AiEnergyCubit>(
    () => AiEnergyCubit(di<AiEnergyRepository>()),
  );
}
