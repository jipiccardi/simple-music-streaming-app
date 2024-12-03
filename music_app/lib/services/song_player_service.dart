import 'dart:developer';

import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  final AudioPlayer _player;

  factory AudioPlayerService() {
    return _instance;
  }

  AudioPlayerService._internal() : _player = AudioPlayer() {
    log('AudioPlayerService instance created');
  }

  AudioPlayer get player => _player;
}
