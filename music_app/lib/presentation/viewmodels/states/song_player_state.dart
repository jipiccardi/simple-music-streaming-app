import 'package:music_app/data/models/song.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';

class SongPlayerState {
  final BaseScreenState screenState;
  final Song? song;
  final bool? isPlaying;

  const SongPlayerState({
    this.screenState = const BaseScreenState.idle(),
    this.song,
    this.isPlaying,
  });

  SongPlayerState copyWith({
    BaseScreenState? screenState,
    Song? song,
    bool? isPlaying,
  }) {
    return SongPlayerState(
      screenState: screenState ?? this.screenState,
      song: song ?? this.song,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
