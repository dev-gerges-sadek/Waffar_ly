import 'music_info.dart';
import 'smart_device.dart';

/// Domain entity for a smart room.
/// Room definitions live in [RoomRegistry] (app_constants.dart).
/// Per-room device states stream from Firestore via [SmartRoomRepository].
class SmartRoom {
  const SmartRoom({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.temperature,
    required this.airHumidity,
    required this.lights,
    required this.airCondition,
    required this.timer,
    required this.musicInfo,
  });

  final String      id;
  final String      name;
  final String      imageUrl;
  final double      temperature;
  final double      airHumidity;
  final SmartDevice lights;
  final SmartDevice airCondition;
  final SmartDevice timer;
  final MusicInfo   musicInfo;

  SmartRoom copyWith({
    String?      id,
    String?      name,
    String?      imageUrl,
    double?      temperature,
    double?      airHumidity,
    SmartDevice? lights,
    SmartDevice? airCondition,
    SmartDevice? timer,
    MusicInfo?   musicInfo,
  }) =>
      SmartRoom(
        id:           id           ?? this.id,
        name:         name         ?? this.name,
        imageUrl:     imageUrl     ?? this.imageUrl,
        temperature:  temperature  ?? this.temperature,
        airHumidity:  airHumidity  ?? this.airHumidity,
        lights:       lights       ?? this.lights,
        airCondition: airCondition ?? this.airCondition,
        timer:        timer        ?? this.timer,
        musicInfo:    musicInfo    ?? this.musicInfo,
      );
}
