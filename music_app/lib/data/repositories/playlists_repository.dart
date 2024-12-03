import 'package:music_app/data/models/playlist.dart';
import 'package:music_app/services/firestore_database_service.dart';

abstract interface class PlaylistsRepository {
  Future<List<Playlist>> getAllPlaylistsByUserId(String userId);
  Future<void> removePlaylist(String id);
  Future<void> addPlaylist(Playlist playlist);
  Future<void> renamePlaylist(String id, String name);
  Future<void> updateSongs(String id, List<String> songs);
  Future<void> updateCoverArt(String id, String coverArt);
}

class FirebasePlaylistsRepository implements PlaylistsRepository {
  final _firestore = FirestoreDatabaseService().firestore;

  @override
  Future<List<Playlist>> getAllPlaylistsByUserId(String userId) async {
    final querySnapshot = await _firestore.collection('playlists').where('userId', isEqualTo: userId).get();

    return querySnapshot.docs.map((doc) {
      return Playlist.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  @override
  Future<void> removePlaylist(String id) async {
    await _firestore.collection('playlists').doc(id).delete();
  }

  @override
  Future<void> addPlaylist(Playlist playlist) async {
    await _firestore.collection('playlists').add({
      'userId': playlist.userId,
      'name': playlist.name,
      'coverArt': playlist.coverArt,
      'songs': playlist.songs,
    });
  }

  @override
  Future<void> renamePlaylist(String id, String name) async {
    await _firestore.collection('playlists').doc(id).update({'name': name});
  }

  @override
  Future<void> updateSongs(String id, List<String> songs) async {
    await _firestore.collection('playlists').doc(id).update({'songs': songs});
  }

  @override
  Future<void> updateCoverArt(String id, String coverArt) async {
    await _firestore
        .collection('playlists')
        .doc(id)
        .update({'coverArt': coverArt});
  }
}
