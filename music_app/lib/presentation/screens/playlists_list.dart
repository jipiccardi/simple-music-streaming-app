import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/data/models/playlist.dart';
import 'package:music_app/presentation/screens/new_playlist.dart';
import 'package:music_app/presentation/screens/song_player.dart';
import 'package:music_app/presentation/screens/songs_list.dart';
import 'package:music_app/presentation/viewmodels/providers.dart';
import 'package:music_app/presentation/utils/base_screen_state.dart';
import 'package:music_app/presentation/widgets/playlist_item.dart';
import 'package:image_picker/image_picker.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  static const name = 'PlaylistScreen';

  const PlaylistScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(playlistListViewModelProvider.notifier).fetchPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playlistListViewModelProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Playlist'),
        actions: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.plus, size: 30),
              onPressed: () {
                context.pushReplacementNamed(NewPlaylistScreen.name,
                    queryParameters: {'action': 'create'});
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: state.screenState.when(
              idle: () {
                return _Playlist(
                  playlists: state.playlists,
                  onLongPress: (playlist) =>
                      _onPlaylistLongPress(context, playlist),
                  onPlaylistPress: (songsIds) =>
                      _onPlaylistPress(context, songsIds),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error) {
                log('Error: $error');
                return Center(
                  child: Text('Error: $error'),
                );
              },
            ),
          ),
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.music),
                label: 'Songs',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.list),
                label: 'Playlist',
              ),
            ],
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) {
                context.pushReplacementNamed(SongsListScreen.name);
              }
            },
          ),
        ],
      ),
    );
  }

  void _onPlaylistLongPress(BuildContext context, Playlist playlist) {
    final state = ref.read(playlistListViewModelProvider.notifier);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController controller =
                          TextEditingController(text: playlist.name);
                      return AlertDialog(
                        title: const Text('Rename Playlist'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter new playlist name',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final newName = controller.text.trim();
                              if (newName.isNotEmpty) {
                                if (context.mounted) {
                                  state.renamePlaylist(
                                      playlist.id!, controller.text);
                                  state.fetchPlaylists();
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              }
                            },
                            child: const Text('Rename'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_box),
                title: const Text('Add/Remove Songs'),
                onTap: () {
                  context.pushReplacementNamed(NewPlaylistScreen.name,
                      queryParameters: {'action': 'edit', 'id': playlist.id!},
                      extra: playlist.songs);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Add Cover'),
                onTap: () async {
                  final pickedImg = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedImg != null) {
                    state.addPlaylistCover(
                        playlist.id!,
                        playlist.coverArt == null ? '' : playlist.coverArt!,
                        File(pickedImg.path));
                  }

                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Playlist'),
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Playlist'),
                        content: const Text(
                            'Are you sure you want to delete this playlist?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              state.deletePlaylist(
                                  playlist.id!,
                                  playlist.coverArt == null
                                      ? ''
                                      : playlist.coverArt!);
                              state.fetchPlaylists();
                              if (context.mounted) Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onPlaylistPress(BuildContext context, List<String> songsIds) async {
    final playerNotifier = ref.read(songPlayerViewModelProvider('').notifier);
    if (songsIds.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            const SnackBar(
                duration: Duration(milliseconds: 500),
                content: Text('Playlist with no items')),
          )
          .closed
          .then((reason) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }
      });
      return;
    }
    await context
        .pushNamed(SongPlayerScreen.name,
            pathParameters: {'id': songsIds[0]}, extra: songsIds)
        .then((_) {
      playerNotifier.stopSong();
    });
  }
}

class _Playlist extends StatelessWidget {
  const _Playlist({
    required this.playlists,
    required this.onLongPress,
    required this.onPlaylistPress,
  });

  final List<Playlist> playlists;
  final Function(List<String>) onPlaylistPress;
  final Function(Playlist) onLongPress;

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) {
      return const Center(
        child: Text('No playlists available'),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 40),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return PlaylistItem(
                playlist: playlist,
                onTap: () => onPlaylistPress(playlist.songs!),
                onLongPress: () => onLongPress(playlist),
              );
            },
          ),
        ),
      ],
    );
  }
}
