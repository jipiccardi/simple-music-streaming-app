import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/data/models/playlist.dart';
import 'package:music_app/data/repositories/providers.dart';
import 'package:music_app/data/repositories/songs_repository.dart';
import 'package:music_app/data/repositories/playlists_repository.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';
import 'package:music_app/presentation/viewmodels/states/new_playlist_state.dart';
import 'package:music_app/main.dart';

class NewPlaylistNotifier
    extends AutoDisposeFamilyNotifier<NewPlaylistState, String> {
  late final SongsRepository songsRepository =
      ref.read(songsRepositoryProvider);

  late final PlaylistsRepository playlistRepository =
      ref.read(playlistsRepositoryProvider);

  @override
  NewPlaylistState build(String arg) {
    return const NewPlaylistState();
  }

  Future<void> setAvailableSongs() async {
    state = state.copyWith(screenState: const BaseScreenState.loading());

    try {
      final songs = await songsRepository.getAllSongs();
      state = state.copyWith(
          screenState: const BaseScreenState.idle(), songs: songs);
    } catch (error) {
      state = state.copyWith(
        screenState: BaseScreenState.error(error.toString()),
      );
    }
  }

  Future<void> savePlaylist(String playlistName, List<String> songsIds) async {
    state = state.copyWith(screenState: const BaseScreenState.loading());

    try {
      await playlistRepository.addPlaylist(Playlist(
        userId: sessionUserId,
        name: playlistName,
        songs: songsIds,
      ));
      state = state.copyWith(screenState: const BaseScreenState.idle());
    } catch (error) {
      state = state.copyWith(
        screenState: BaseScreenState.error(error.toString()),
      );
    }
  }

  Future<void> updateSongs(String id, List<String> songs) async {
    state = state.copyWith(
      screenState: const BaseScreenState.loading(),
    );

    try {
      await playlistRepository.updateSongs(id, songs);
      state = state.copyWith(
        screenState: const BaseScreenState.idle(),
      );
    } catch (error) {
      state = state.copyWith(
        screenState: BaseScreenState.error(error.toString()),
      );
    }
  }
}
