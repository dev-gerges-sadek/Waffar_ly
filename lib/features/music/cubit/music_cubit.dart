import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart' show PlayerState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waffar_ly_app/core/services/music_service.dart';
import '../data/deezer_data_source.dart';
import '../models/music_track.dart';
import 'music_states.dart';

class MusicCubit extends Cubit<MusicState> {
  MusicCubit({DeezerDataSource? source, MusicService? musicService})
    : _source = source ?? GetIt.I<DeezerDataSource>(),
      _musicService = musicService ?? GetIt.I<MusicService>(),
      super(const MusicInitial()) {
    _playbackSub = _musicService.playerStateStream.listen((_) {
      _syncPlayback();
    });
    loadTopCharts();
  }

  final DeezerDataSource _source;
  final MusicService _musicService;
  late final StreamSubscription<PlayerState> _playbackSub;

  MusicTrack? get nowPlaying => _musicService.currentTrack;
  bool get isPlaying => _musicService.isPlaying;

  // ── Data ──────────────────────────────────────────────────────────────────

  Future<void> loadTopCharts() async {
    emit(const MusicLoading());
    try {
      final tracks = await _source.fetchTopTracks();
      await _musicService.initPlaylist(tracks);
      emit(
        MusicLoaded(
          tracks,
          query: '',
          isTopCharts: true,
          nowPlayingId: _musicService.currentTrack?.id,
        ),
      );
    } on DioException catch (e) {
      emit(MusicError(_dioMsg(e)));
    } catch (e) {
      emit(const MusicError('load_failed'));
    }
  }

  Future<void> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      await loadTopCharts();
      return;
    }
    emit(const MusicLoading());
    try {
      final tracks = await _source.search(q);
      await _musicService.initPlaylist(tracks);
      emit(
        MusicLoaded(
          tracks,
          query: q,
          isTopCharts: false,
          nowPlayingId: _musicService.currentTrack?.id,
        ),
      );
    } on DioException catch (e) {
      emit(MusicError(_dioMsg(e)));
    } catch (_) {
      emit(const MusicError('search_failed'));
    }
  }

  // ── Playback ──────────────────────────────────────────────────────────────

  Future<void> playTrack(MusicTrack track) async {
    await _musicService.playTrack(track);
    _syncPlayback();
  }

  Future<void> togglePlayPause() async {
    await _musicService.togglePlayPause();
    _syncPlayback();
  }

  Future<void> nextTrack() async {
    await _musicService.next();
    _syncPlayback();
  }

  Future<void> previousTrack() async {
    await _musicService.previous();
    _syncPlayback();
  }

  Future<void> stopPlayback() async {
    await _musicService.stop();
    _syncPlayback();
  }

  void _syncPlayback() {
    if (isClosed) return;
    final s = state;
    if (s is MusicLoaded) {
      emit(
        MusicLoaded(
          s.tracks,
          query: s.query,
          isTopCharts: s.isTopCharts,
          nowPlayingId: _musicService.currentTrack?.id,
        ),
      );
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _dioMsg(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'timeout';
    }
    return 'network';
  }

  @override
  Future<void> close() async {
    await _playbackSub.cancel();
    return super.close();
  }
}
