import 'package:music_app/data/models/playlist.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';

class PlaylistsState {
  final BaseScreenState screenState;
  final List<Playlist> playlists;
  

  const PlaylistsState({
    this.screenState = const BaseScreenState.idle(),
    this.playlists = const[]
  });

  PlaylistsState copyWith({
    BaseScreenState? screenState,
    List<Playlist>? playlists,
  }){
    return PlaylistsState(
      screenState: screenState ?? this.screenState,
      playlists: playlists ?? this.playlists,
    );
  }
}