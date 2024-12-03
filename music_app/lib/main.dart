import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_router.dart';

String sessionUserId = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _loadSession();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp.router(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      routerConfig: appRouter,
    ));
  }
}

Future<void> _loadSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  sessionUserId = prefs.getString('user_id') ?? '';
  return;
}
