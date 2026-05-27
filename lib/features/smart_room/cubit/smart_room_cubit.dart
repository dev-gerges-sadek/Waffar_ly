import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waffar_ly_app/features/smart_room/cubit/smart_room_states.dart';
import '../data/smart_room_repository.dart';



class SmartRoomCubit extends Cubit<SmartRoomState> {
  SmartRoomCubit(this._repository) : super(SmartRoomInitial());

  final SmartRoomRepository _repository;

  Future<void> loadRooms() async {
    if (isClosed) return;
    emit(SmartRoomLoading());
    try {
      final rooms = await _repository.getRooms();
      if (!isClosed) emit(SmartRoomLoaded(rooms));
    } catch (e) {
      if (!isClosed) emit(SmartRoomError(e.toString()));
    }
  }
}
