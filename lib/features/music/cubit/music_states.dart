import '../models/music_track.dart';

abstract class MusicState {}

class MusicInitial  extends MusicState {}
class MusicLoading  extends MusicState {}
class MusicError    extends MusicState { MusicError(this.message); final String message; }

class MusicLoaded extends MusicState {
  MusicLoaded(this.tracks, this.query);
  final List<MusicTrack> tracks;
  final String           query;
}
