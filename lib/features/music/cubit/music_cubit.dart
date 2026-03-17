import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/music_track.dart';
import 'music_states.dart';

class MusicCubit extends Cubit<MusicState> {
  MusicCubit() : super(MusicInitial()) {
    search('top hits 2024');
  }

  final _dio = Dio();

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    emit(MusicLoading());
    try {
      final response = await _dio.get(
        'https://itunes.apple.com/search',
        queryParameters: {
          'term':   query.trim(),
          'media':  'music',
          'limit':  30,
          'entity': 'song',
        },
        options: Options(
          sendTimeout:    const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      final results = (response.data['results'] as List)
          .map((e) => MusicTrack.fromJson(e as Map<String, dynamic>))
          .where((t) => t.previewUrl.isNotEmpty)
          .toList();

      emit(MusicLoaded(results, query.trim()));
    } on DioException catch (e) {
      final msg = e.type == DioExceptionType.connectionTimeout
          ? 'Connection timeout. Check your internet.'
          : 'Could not load songs. Please try again.';
      emit(MusicError(msg));
    } catch (_) {
      emit(MusicError('Something went wrong. Please try again.'));
    }
  }
}
