import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class FirestoreAuthService {
  static final FirestoreAuthService _instance = FirestoreAuthService._internal();
  final FirebaseAuth _auth;
  
  factory FirestoreAuthService() {
    return _instance;
  }

  FirestoreAuthService._internal() : _auth = FirebaseAuth.instance{
    log('FirestoreAuthService instance created');
  }

  FirebaseAuth get auth => _auth;
}