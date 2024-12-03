import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer';

class FirestoreStorageService {
  static final FirestoreStorageService _instance = FirestoreStorageService._internal();
  final FirebaseStorage _firestore;

  factory FirestoreStorageService() {
    return _instance;
  }

  FirestoreStorageService._internal() : _firestore = FirebaseStorage.instance {
    log('FirestoreStoreage instance created');
  }

  FirebaseStorage get firestore => _firestore;
}
