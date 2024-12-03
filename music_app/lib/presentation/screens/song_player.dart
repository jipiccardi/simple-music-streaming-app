import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';
import 'package:music_app/presentation/viewmodels/providers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SongPlayerScreen extends ConsumerStatefulWidget {
  static const name = 'SongPlayerScreen';
  const SongPlayerScreen(
      {super.key, required this.songId, required this.playlist});

  final String songId;
  final List<String> playlist;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SongPlayerScreenState();
}

class _SongPlayerScreenState extends ConsumerState<SongPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref
          .read(songPlayerViewModelProvider(widget.songId).notifier)
          .onSongFinish();

      await ref
          .read(songPlayerViewModelProvider(widget.songId).notifier)
          .setSong(widget.songId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(songPlayerViewModelProvider(widget.songId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player'),
      ),
      body: state.screenState.when(
        idle: () {
          if (state.song == null) {
            return const Center(child: Text('Unexpected error, try again'));
          }
          return _SongPlayer(
            song: state.song!,
            isPlaying: state.isPlaying!,
            playAndStopSong: (song) => _playAndStopSong(song),
            nextSong: (id) => _nextSong(id),
            previousSong: (id) => _previousSong(id),
            forward: () => forward(),
            backward: () => backward(),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Future<void> _playAndStopSong(Song song) async {
    ref
        .read(songPlayerViewModelProvider(widget.songId).notifier)
        .tooglePlayStatus(song);
  }

  Future<void> _nextSong(String currentId) async {
    final currentIndex = widget.playlist.indexOf(currentId);
    String nextId;
    if (currentIndex == widget.playlist.length - 1) {
      nextId = widget.playlist[0];
    } else {
      nextId = widget.playlist[currentIndex + 1];
    }

    ref
        .read(songPlayerViewModelProvider(widget.songId).notifier)
        .setSong(nextId);
  }

  Future<void> _previousSong(String currentId) async {
    final currentIndex = widget.playlist.indexOf(currentId);
    String previousId;
    if (currentIndex == 0) {
      previousId = widget.playlist[0];
    } else {
      previousId = widget.playlist[currentIndex - 1];
    }

    ref
        .read(songPlayerViewModelProvider(widget.songId).notifier)
        .setSong(previousId);
  }

  Future<void> forward() async {
    ref.read(songPlayerViewModelProvider(widget.songId).notifier).fastFoward();
  }

  Future<void> backward() async {
    ref.read(songPlayerViewModelProvider(widget.songId).notifier).backWard();
  }
}

class _SongPlayer extends StatelessWidget {
  const _SongPlayer({
    required this.song,
    required this.isPlaying,
    required this.playAndStopSong,
    required this.nextSong,
    required this.previousSong,
    required this.forward,
    required this.backward,
  });

  final Song song;
  final bool isPlaying;

  final Future<void> Function(Song) playAndStopSong;
  final Future<void> Function(String) nextSong;
  final Future<void> Function(String) previousSong;
  final Future<void> Function() forward;
  final Future<void> Function() backward;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                song.title,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: 500,
                  height: 500,
                  child: PageView(
                    children: [
                      Center(
                        child: song.coverArt != null
                            ? FadeInImage.assetNetwork(
                                placeholder:
                                    'assets/images/default_art_cover.png',
                                image: song.coverArt!,
                                width: 300,
                                height: 300,
                              )
                            : Image.asset(
                                'assets/images/default_art_cover.png',
                                width: 300,
                                height: 300,
                              ),
                      ),
                      if (song.getMetadata().isNotEmpty)
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              song.getMetadata(),
                              style: const TextStyle(
                                  fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      backward();
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.arrowRotateLeft,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      forward();
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.arrowRotateRight,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      previousSong(song.id);
                    },
                    child:
                        const FaIcon(FontAwesomeIcons.backwardStep, size: 35),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () {
                      playAndStopSong(song);
                    },
                    child: FaIcon(
                      isPlaying
                          ? FontAwesomeIcons.pause
                          : FontAwesomeIcons.play,
                      size: 50,
                    ),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () {
                      nextSong(song.id);
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.forwardStep,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
