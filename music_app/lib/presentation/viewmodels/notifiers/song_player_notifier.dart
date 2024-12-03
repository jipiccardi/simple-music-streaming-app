import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data/repositories/providers.dart';
import 'package:music_app/data/repositories/songs_repository.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';
import 'package:music_app/presentation/viewmodels/states/song_player_state.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/services/song_player_service.dart';

class SongPlayerNotifier
    extends AutoDisposeFamilyNotifier<SongPlayerState, String> {
  final player = AudioPlayerService().player;

  late final SongsRepository songsRepository =
      ref.read(songsRepositoryProvider);

  @override
  SongPlayerState build(String arg) {
    return const SongPlayerState(isPlaying: false);
  }

  Future<void> setSong(String songId) async {
    state = state.copyWith(screenState: const BaseScreenState.loading());
    try {
      final song = await songsRepository.getSongById(songId);
      await player.setAudioSource(AudioSource.uri(Uri.parse(song!.filePath)));
      player.play();
      state = state.copyWith(
          screenState: const BaseScreenState.idle(),
          song: song,
          isPlaying: true);
    } catch (error) {
      state = state.copyWith(
        screenState: BaseScreenState.error(error.toString()),
      );
    }
  }

  Future<void> tooglePlayStatus(Song song) async {
    if (player.playing) {
      player.pause();
      state = state.copyWith(song: song, isPlaying: false);
    } else {
      player.play();
      state = state.copyWith(song: song, isPlaying: true);
    }
  }

  Future<void> stopSong() async {
    player.stop();
  }

  Future<void> fastFoward() async {
    player.seek(Duration(seconds: player.position.inSeconds + 10));
  }

  Future<void> backWard() async {
    player.seek(Duration(seconds: player.position.inSeconds - 10));
  }

  Future<void> onSongFinish() async {
    player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        player.stop();
        player.seek(Duration.zero);
        state = state.copyWith(isPlaying: false);
      }
    });
  }
}
