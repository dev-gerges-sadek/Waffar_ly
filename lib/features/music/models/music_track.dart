class MusicTrack {
  const MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.artworkUrl,
    required this.previewUrl,
    required this.durationSeconds,
    this.deezerUrl = '',
  });

  final int    id;
  final String title;
  final String artist;
  final String album;
  final String artworkUrl;
  final String previewUrl;   // 30-sec MP3 preview
  final int    durationSeconds;
  final String deezerUrl;

  String get duration {
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// Maps one Deezer track JSON object.
  /// Deezer API: https://api.deezer.com/search?q=query
  factory MusicTrack.fromDeezer(Map<String, dynamic> j) {
    final album  = j['album']  as Map<String, dynamic>? ?? {};
    final artist = j['artist'] as Map<String, dynamic>? ?? {};
    return MusicTrack(
      id:              j['id'] is int ? j['id'] as int : int.tryParse(j['id'].toString()) ?? 0,
      title:           j['title']           as String? ?? '',
      artist:          artist['name']       as String? ?? '',
      album:           album['title']       as String? ?? '',
      artworkUrl:      album['cover_medium'] as String? ?? album['cover'] as String? ?? '',
      previewUrl:      j['preview']         as String? ?? '',
      durationSeconds: j['duration'] is int
          ? j['duration'] as int
          : int.tryParse(j['duration'].toString()) ?? 0,
      deezerUrl:       j['link']            as String? ?? '',
    );
  }
}
