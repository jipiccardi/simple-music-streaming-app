import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/presentation/viewmodels/notifiers/new_playlist_notifier.dart';
import 'package:music_app/presentation/viewmodels/notifiers/sign_in_notifier.dart';
import 'package:music_app/presentation/viewmodels/notifiers/sign_up_notifier.dart';
import 'package:music_app/presentation/viewmodels/notifiers/song_player_notifier.dart';
import 'package:music_app/presentation/viewmodels/states/new_playlist_state.dart';
import 'package:music_app/presentation/viewmodels/states/playlists_list_state.dart';
import 'package:music_app/presentation/viewmodels/notifiers/playlists_list_notifier.dart';
import 'package:music_app/presentation/viewmodels/states/sign_in_state.dart';
import 'package:music_app/presentation/viewmodels/states/sign_up_state.dart';
import 'package:music_app/presentation/viewmodels/states/song_player_state.dart';

import 'states/songs_list_state.dart';
import 'notifiers/songs_list_notifier.dart';

final songsListViewModelProvider =
    NotifierProvider<SongsListNotifier, SongsListState>(SongsListNotifier.new);

final songPlayerViewModelProvider = AutoDisposeNotifierProviderFamily<
    SongPlayerNotifier, SongPlayerState, String>(SongPlayerNotifier.new);

final playlistListViewModelProvider =
    NotifierProvider<PlaylistsNotifier, PlaylistsState>(PlaylistsNotifier.new);

final newPlaylistViewModelProvider = AutoDisposeNotifierProviderFamily<
    NewPlaylistNotifier, NewPlaylistState, String>(NewPlaylistNotifier.new);

final signUpViewModelProvider =
    NotifierProvider<SignUpNotifier, SignUpState>(SignUpNotifier.new);

final signInViewModelProvider =
    NotifierProvider<SignInNotifier, SignInState>(SignInNotifier.new);
