import 'package:music_app/services/firestore_database_service.dart';
import '../models/song.dart';

abstract interface class SongsRepository {
  Future<List<Song>> getAllSongs();
  Future<Song?> getSongById(String id);
}

class FirebaseSongsRepository implements SongsRepository {
  final _firestore = FirestoreDatabaseService().firestore;


  @override
  Future<List<Song>> getAllSongs() async {
    final querySnapshot = await _firestore.collection('songs').get();

    return querySnapshot.docs.map((doc) {
      return Song.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  @override
  Future<Song?> getSongById(String songId) async {
    final doc = await _firestore.collection('songs').doc(songId).get();
    return doc.exists ? Song.fromFirestore(doc.data()!, doc.id) : null;
  }
}
