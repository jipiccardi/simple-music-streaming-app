import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/data/repositories/songs_repository.dart';
import 'package:music_app/main.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';
import 'package:music_app/presentation/viewmodels/states/songs_list_state.dart';
import 'package:music_app/services/firestore_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/providers.dart';

class SongsListNotifier extends Notifier<SongsListState> {
  late final SongsRepository songsRepository =
      ref.read(songsRepositoryProvider);

  late final FirestoreAuthService authService = FirestoreAuthService();

  @override
  SongsListState build() {
    return const SongsListState();
  }

  Future<void> fetchSongs() async {
    state = state.copyWith(
      screenState: const BaseScreenState.loading(),
    );

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

  Future<void> logOut() async {
    try {
      await authService.auth.signOut();
      sessionUserId = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (error) {
      state = state.copyWith(
        screenState: BaseScreenState.error(error.toString()),
      );
    }
  }
}
