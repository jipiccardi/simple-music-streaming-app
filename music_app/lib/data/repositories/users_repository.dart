import 'package:music_app/data/models/user.dart';
import 'package:music_app/services/firestore_database_service.dart';

abstract interface class UsersRepository {
  Future<AppUser?> getUser(String id);
  Future<void> createUser(AppUser user);
}

class FirebaseUsersRepository implements UsersRepository {
  final _firestore = FirestoreDatabaseService().firestore;

  @override
  Future<AppUser?> getUser(String id) async {
    final doc = await _firestore.collection('users').doc(id).get();
    return doc.exists ? AppUser.fromFirestore(doc.data()!, doc.id) : null;
  }

  @override
  Future<void> createUser(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set({
      'email': user.email,
    });
  }
}