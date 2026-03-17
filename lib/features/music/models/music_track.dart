class MusicTrack {
  const MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.artworkUrl,
    required this.previewUrl,
    required this.trackTimeMillis,
  });

  final int    id;
  final String title;
  final String artist;
  final String album;
  final String artworkUrl;
  final String previewUrl;
  final int    trackTimeMillis;

  String get duration {
    final total = trackTimeMillis ~/ 1000;
    final m = total ~/ 60;
    final s = total % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  factory MusicTrack.fromJson(Map<String, dynamic> json) {
    return MusicTrack(
      id:               json['trackId']       as int,
      title:            json['trackName']     as String,
      artist:           json['artistName']    as String,
      album:            json['collectionName']as String? ?? '',
      artworkUrl:       (json['artworkUrl100'] as String?)
                            ?.replaceAll('100x100', '300x300') ?? '',
      previewUrl:       json['previewUrl']    as String? ?? '',
      trackTimeMillis:  json['trackTimeMillis'] as int? ?? 0,
    );
  }
}
