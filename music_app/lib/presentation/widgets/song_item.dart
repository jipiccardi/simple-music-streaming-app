import 'package:flutter/material.dart';
import 'package:music_app/data/models/song.dart';

class SongItem extends StatelessWidget {
  const SongItem({
    super.key,
    required this.song,
    this.onTap,
  });

  final Song song;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text(song.title, style: const TextStyle(fontSize: 20)),
          onTap: () => onTap?.call(),
          leading: song.coverArt != null
              ? FadeInImage.assetNetwork(
                  placeholder: 'assets/images/default_art_cover.png',
                  image: song.coverArt!,
                  width: 30,
                  height: 30,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_art_cover.png',
                      width: 30,
                      height: 30,
                    );
                  },
                )
              : Image.asset(
                  'assets/images/default_art_cover.png',
                  width: 30,
                  height: 30,
                ),
        ));
  }
}
