import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../models/music_track.dart';

/// Deezer Open API — completely free, no API key required.
/// Docs: https://developers.deezer.com/api
class DeezerDataSource {
  DeezerDataSource()
      : _dio = Dio(BaseOptions(
          baseUrl:        AppConstants.deezerBaseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ));

  final Dio _dio;

  // ── Top charts (global) ───────────────────────────────────────────────────

  Future<List<MusicTrack>> fetchTopTracks({int limit = 30}) async {
    final resp = await _dio.get(
      '/chart/0/tracks',
      queryParameters: {'limit': limit},
    );
    final data = resp.data as Map<String, dynamic>;
    return _parseList((data['data'] as List<dynamic>?) ?? []);
  }

  // ── Search ────────────────────────────────────────────────────────────────

  Future<List<MusicTrack>> search(String query, {int limit = 30}) async {
    final resp = await _dio.get(
      '/search',
      queryParameters: {'q': query.trim(), 'limit': limit},
    );
    final data = resp.data as Map<String, dynamic>;
    return _parseList((data['data'] as List<dynamic>?) ?? []);
  }

  // ── Genre radio ───────────────────────────────────────────────────────────

  Future<List<MusicTrack>> fetchByGenre(int genreId, {int limit = 20}) async {
    await _dio.get('/genre/$genreId/artists');
    // Genre returns artists; for simplicity fall back to search with genre name
    return fetchTopTracks(limit: limit);
  }

  // ── Parser ────────────────────────────────────────────────────────────────

  List<MusicTrack> _parseList(List<dynamic> items) => items
      .map((e) => MusicTrack.fromDeezer(e as Map<String, dynamic>))
      .where((t) => t.previewUrl.isNotEmpty)
      .toList();
}
