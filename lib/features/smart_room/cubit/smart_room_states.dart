import 'package:waffar_ly_app/core/shared/domain/entities/smart_room.dart';

sealed class SmartRoomState {}
class SmartRoomInitial extends SmartRoomState {}
class SmartRoomLoading extends SmartRoomState {}
class SmartRoomLoaded  extends SmartRoomState {
  SmartRoomLoaded(this.rooms);
  final List<SmartRoom> rooms;
}
class SmartRoomError extends SmartRoomState {
  SmartRoomError(this.message);
  final String message;
}