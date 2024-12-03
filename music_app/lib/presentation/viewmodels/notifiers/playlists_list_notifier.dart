import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/main.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:music_app/data/repositories/playlists_repository.dart';
import 'package:music_app/data/repositories/providers.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';
import 'package:music_app/presentation/viewmodels/states/playlists_list_state.dart';
import 'package:music_app/services/firestore_storage_service.dart';

class PlaylistsNotifier extends Notifier<PlaylistsState> {
  late final PlaylistsRepository playlistsRepository =
      ref.read(playlistsRepositoryProvider);

  late final FirestoreStorageService firestoreStorage =
      FirestoreStorageService();

  @override
  PlaylistsState build() {
    return const PlaylistsState();
  }

  Future<void> fetchPlaylists() async {
    state = state.copyWith(
      screenState: const BaseScreenState.loading(),
    );

    try {
      final playlists = await playlistsRepository.getAllPlaylistsByUserId(sessionUserId);
      state = state.copyWith(
          screenState: const BaseScreenState.idle(), playlists: playlists);
    } catch (error) {
      state = state.copyWith(
        screenState: BaseScreenState.error(error.toString()),
      );
    }
  }

  Future<void> deletePlaylist(String id, String coverArtURL) async {
    state = state.copyWith(
      screenState: const BaseScreenState.loading(),
    );

    try {
      if (coverArtURL.isNotEmpty) {
        firestoreStorage.firestore.refFromURL(coverArtURL).delete();
      }

      await playlistsRepository.removePlaylist(id);
      state = state.copyWith(
        screenState: const BaseScreenState.idle(),
      );
    } catch (error) {
      state = state.copyWith(
        screenState: BaseScreenState.error(error.toString()),
      );
    }
  }

  Future<void> renamePlaylist(String id, String newName) async {
    state = state.copyWith(
      screenState: const BaseScreenState.loading(),
    );

    try {
      await playlistsRepository.renamePlaylist(id, newName);
      state = state.copyWith(
        screenState: const BaseScreenState.idle(),
      );
    } catch (error) {
      state = state.copyWith(
        screenState: BaseScreenState.error(error.toString()),
      );
    }
  }

  Future<void> addPlaylistCover(
      String id, String oldImgURL, File newImg) async {
    state = state.copyWith(
      screenState: const BaseScreenState.loading(),
    );
    try {
      if (oldImgURL.isNotEmpty) {
        firestoreStorage.firestore.refFromURL(oldImgURL).delete();
      }

      final filename = const Uuid().v4();

      final res = firestoreStorage.firestore
          .ref('playlist_cover/$filename.png')
          .putFile(newImg);

      res.whenComplete(() async {
        final downloadUrl = await firestoreStorage.firestore
            .ref('playlist_cover/$filename.png')
            .getDownloadURL();

        await playlistsRepository.updateCoverArt(id, downloadUrl);

        final playlists = await playlistsRepository.getAllPlaylistsByUserId(sessionUserId);

        state = state.copyWith(
          screenState: const BaseScreenState.idle(),
          playlists: playlists,
        );
      });

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
