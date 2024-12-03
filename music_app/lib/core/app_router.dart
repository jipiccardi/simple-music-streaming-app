import 'package:go_router/go_router.dart';
import 'package:music_app/main.dart';
import 'package:music_app/presentation/screens/new_playlist.dart';
import 'package:music_app/presentation/screens/sign_in.dart';
import 'package:music_app/presentation/screens/sign_up.dart';
import 'package:music_app/presentation/screens/song_player.dart';
import '../presentation/screens/playlists_list.dart';
import '../presentation/screens/songs_list.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        name: SignInScreen.name,
        builder: (context, state) => const SignInScreen(),
        redirect: (context, state) {
          if (sessionUserId != '') {
            return '/songs';
          }
          return '/';
        }),
    GoRoute(
        path: '/signup',
        name: SignUpScreen.name,
        builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/songs',
      name: SongsListScreen.name,
      builder: (context, state) => const SongsListScreen(),
    ),
    GoRoute(
      path: '/songs/:id',
      name: SongPlayerScreen.name,
      builder: (context, state) => SongPlayerScreen(
        songId: state.pathParameters['id'] ?? '',
        playlist: state.extra as List<String>,
      ),
    ),
    GoRoute(
      path: '/playlist',
      name: PlaylistScreen.name,
      builder: (context, state) => const PlaylistScreen(),
    ),
    GoRoute(
      path: '/playlist/new-edit',
      name: NewPlaylistScreen.name,
      builder: (context, state) => NewPlaylistScreen(
        action: state.uri.queryParameters['action'] ?? '',
        playlistId: state.uri.queryParameters['id'] ?? '',
        paylistSongs: state.extra != null ? state.extra as List<String> : [],
      ),
    )
  ],
);
