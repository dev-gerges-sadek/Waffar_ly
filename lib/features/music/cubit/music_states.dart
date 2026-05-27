import '../models/music_track.dart';

sealed class MusicState { const MusicState(); }

class MusicInitial extends MusicState { const MusicInitial(); }
class MusicLoading extends MusicState { const MusicLoading(); }

class MusicError extends MusicState {
  const MusicError(this.message);
  final String message;
}

class MusicLoaded extends MusicState {
  const MusicLoaded(
    this.tracks, {
    required this.query,
    required this.isTopCharts,
    this.nowPlayingId,
  });
  final List<MusicTrack> tracks;
  final String           query;
  final bool             isTopCharts;
  final int?             nowPlayingId;
}
