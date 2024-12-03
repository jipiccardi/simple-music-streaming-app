import 'package:flutter/material.dart';
import 'package:music_app/data/models/playlist.dart';

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({
    super.key,
    required this.playlist,
    this.onTap,
    this.onLongPress,
  });

  final Playlist playlist;
  final Function? onTap;
  final Function? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Column(
        children: [
          playlist.coverArt != null
              ? FadeInImage.assetNetwork(
                  placeholder: 'assets/images/default_art_cover.png',
                  image: playlist.coverArt!,
                  width: 150,
                  height: 150,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_art_cover.png',
                      width: 150,
                      height: 150,
                    );
                  },
                )
              : Image.asset(
                  'assets/images/default_art_cover.png',
                  width: 150,
                  height: 150,
                ),
          Text(playlist.name),
        ],
      ),
      onLongPress: () => onLongPress?.call(),
    );
  }
}
