import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import '../../features/ai_dashboard/cubit/ai_energy_cubit.dart';
import '../../features/ai_dashboard/data/ai_energy_repository.dart';
import '../../features/alert/data/repositories/anomaly_repository.dart';
import '../../features/auth/firebase/auth_service.dart';
import '../../features/chatbot/data/chatbot_repository_impl.dart';
import '../../features/chatbot/domain/repositories/chatbot_repository.dart';
import '../../features/devices/data/combined_device_repository.dart';
import '../../features/devices/data/firestore_devices_data_source.dart';
import '../../features/devices/data/hardware_device_repository_impl.dart';
import '../../features/devices/data/simulation_device_repository_impl.dart';
import '../../features/devices/domain/repositories/device_repository.dart';
import '../../features/emergency/data/emergency_repository.dart';
import '../../features/hardware/data/hardware_repository.dart';
import '../../features/music/data/deezer_data_source.dart';
import '../../features/smart_room/cubit/smart_room_cubit.dart';
import '../../features/smart_room/data/smart_room_repository.dart';
import '../../features/weather/data/weather_repository.dart';
import '../data/home_scope.dart';
import '../../features/chatbot/data/chatbot_context_source.dart';
import '../services/music_service.dart';

final GetIt di = GetIt.instance;

/// Single composition root. Cubits are ALWAYS `registerFactory` (a cubit is
/// closed by its BlocProvider, so a singleton would be dead on 2nd use);
/// repositories/services are lazy singletons.
Future<void> setupDependencies() async {
  if (di.isRegistered<MusicService>()) return;

  // ── External ──────────────────────────────────────────────────────────────
  di.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  di.registerLazySingleton<HomeScope>(
    () => HomeScope(firestore: di<FirebaseFirestore>()),
  );

  // ── Services ──────────────────────────────────────────────────────────────
  di.registerLazySingleton<MusicService>(
    () => MusicService(),
    dispose: (s) => s.dispose(),
  );
  di.registerLazySingleton<AuthService>(() => AuthService());

  // ── Data sources ──────────────────────────────────────────────────────────
  di.registerLazySingleton<FirestoreDevicesDataSource>(
    () => FirestoreDevicesDataSource(di<HomeScope>()),
  );
  di.registerLazySingleton<DeezerDataSource>(() => DeezerDataSource());

  // ── Repositories ──────────────────────────────────────────────────────────
  di.registerLazySingleton<AiEnergyRepository>(() => AiEnergyRepository(di<HomeScope>()));
  di.registerLazySingleton<SmartRoomRepository>(() => SmartRoomRepository(di<HomeScope>()));
  di.registerLazySingleton<EmergencyRepository>(
    () => EmergencyRepository(di<HomeScope>()),
  );
  di.registerLazySingleton<AnomalyRepository>(
    () => AnomalyRepository(di<HomeScope>()),
  );
  di.registerLazySingleton<HardwareRepository>(
    () => HardwareRepository(di<HomeScope>()),
  );
  di.registerLazySingleton<WeatherRepository>(() => WeatherRepository());
  di.registerLazySingleton<ChatbotRepository>(() => ChatbotRepositoryImpl(ChatbotContextSource(di<HomeScope>())));

  di.registerLazySingleton<SimulationDeviceRepositoryImpl>(
    () => SimulationDeviceRepositoryImpl(di<FirestoreDevicesDataSource>()),
  );
  di.registerLazySingleton<HardwareDeviceRepositoryImpl>(
    () => HardwareDeviceRepositoryImpl(di<FirestoreDevicesDataSource>()),
  );
  di.registerLazySingleton<DeviceRepository>(
    () => CombinedDeviceRepository(
      simulationRepository: di<SimulationDeviceRepositoryImpl>(),
      hardwareRepository: di<HardwareDeviceRepositoryImpl>(),
    ),
  );

  // ── Cubits (factories) ────────────────────────────────────────────────────
  di.registerFactory<SmartRoomCubit>(
    () => SmartRoomCubit(di<SmartRoomRepository>()),
  );
  di.registerFactory<AiEnergyCubit>(
    () => AiEnergyCubit(di<AiEnergyRepository>()),
  );
}
