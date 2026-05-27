// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:waffar_ly_app/features/music/models/music_track.dart';

class MusicService {
  MusicService() {
    _player.currentIndexStream.listen((index) {
      if (index != null && index >= 0 && index < _playlist.value.length) {
        _currentTrack.add(_playlist.value[index]);
      }
    });

    _player.playerStateStream.listen((state) {
      if (state.playing && _player.currentIndex != null) {
        final index = _player.currentIndex!;
        if (index >= 0 && index < _playlist.value.length) {
          _currentTrack.add(_playlist.value[index]);
        }
      }
    });
  }

  final AudioPlayer _player = AudioPlayer();
  final BehaviorSubject<List<MusicTrack>> _playlist =
      BehaviorSubject<List<MusicTrack>>.seeded([]);
  final BehaviorSubject<MusicTrack?> _currentTrack =
      BehaviorSubject<MusicTrack?>.seeded(null);

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<MusicTrack?> get currentTrackStream => _currentTrack.stream;
  Stream<List<MusicTrack>> get playlistStream => _playlist.stream;

  MusicTrack? get currentTrack => _currentTrack.valueOrNull;
  bool get isPlaying => _player.playing;
  List<MusicTrack> get playlist => _playlist.value;

  Future<void> initPlaylist(List<MusicTrack> tracks) async {
    final sources = tracks
        .map((track) => AudioSource.uri(Uri.parse(track.previewUrl)))
        .toList();

    _playlist.add(List.unmodifiable(tracks));
    if (sources.isNotEmpty) {
      await _player.setAudioSource(
        ConcatenatingAudioSource(children: sources),
        preload: true,
      );
    }
  }

  Future<void> playTrack(MusicTrack track) async {
    final index = playlist.indexWhere((item) => item.id == track.id);
    if (index == -1) return;
    _currentTrack.add(track);
    await _player.seek(Duration.zero, index: index);
    await _player.play();
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
      return;
    }
    await _player.play();
    return;
  }

  Future<void> next() async {
    if (_player.hasNext) {
      await _player.seekToNext();
      await _player.play();
    }
  }

  Future<void> previous() async {
    if (_player.hasPrevious) {
      await _player.seekToPrevious();
      await _player.play();
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _currentTrack.add(null);
  }

  Future<void> dispose() async {
    await _player.dispose();
    await _playlist.close();
    await _currentTrack.close();
  }
}
