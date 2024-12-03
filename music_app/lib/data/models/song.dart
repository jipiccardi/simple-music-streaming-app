class Song {
  final String id;
  final String title;
  final String? album;
  final String? artist;
  final String? coverArt;
  final String filePath;
  final String? genre;

  Song({
    required this.id,
    required this.title,
    this.album,
    this.artist,
    this.coverArt,
    required this.filePath,
    this.genre,
  });

  factory Song.fromFirestore(Map<String, dynamic> data, String id) {
    return Song(
      id: id,
      title: data['title'],
      album: data['album'],
      artist: data['artist'],
      coverArt: data['coverArt'],
      filePath: data['filePath'],
      genre: data['genre'],
    );
  }

  String getMetadata() {
    List<String> metadata = [];
    genre != null && genre!.isNotEmpty ? metadata.add('Genre: $genre') : null;
    album != null && album!.isNotEmpty ? metadata.add('Album: $album') : null;
    artist != null && artist!.isNotEmpty ? metadata.add('Artist: $artist') : null;
    return metadata.join('\n');
  }
}
