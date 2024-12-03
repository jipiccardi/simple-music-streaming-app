import 'package:music_app/data/models/song.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';

class NewPlaylistState {
  final BaseScreenState screenState;
  final List<Song> songs;

  const NewPlaylistState(
      {this.screenState = const BaseScreenState.idle(), this.songs = const []});

  NewPlaylistState copyWith({
    BaseScreenState? screenState,
    List<Song>? songs,
  }) {
    return NewPlaylistState(
      screenState: screenState ?? this.screenState,
      songs: songs ?? this.songs,
    );
  }
}
