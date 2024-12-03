import 'package:music_app/presentation/utils/base_screen_state.dart';
import '../../../data/models/song.dart';

class SongsListState {
  final BaseScreenState screenState;
  final List<Song> songs;

  const SongsListState({
    this.screenState = const BaseScreenState.idle(),
    this.songs = const[]
  });

  SongsListState copyWith({
    BaseScreenState? screenState,
    List<Song>? songs,
  }){
    return SongsListState(
      screenState: screenState ?? this.screenState,
      songs: songs ?? this.songs,
    );
  }
}