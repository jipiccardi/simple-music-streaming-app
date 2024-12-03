import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabaseService {
  static final FirestoreDatabaseService _instance = FirestoreDatabaseService._internal();
  final FirebaseFirestore _firestore;

  factory FirestoreDatabaseService() {
    return _instance;
  }

  FirestoreDatabaseService._internal() : _firestore = FirebaseFirestore.instance{
    log('FirestoreDatabase instance created');
  }

  FirebaseFirestore get firestore => _firestore;
}
