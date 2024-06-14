import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeTextWithThumbnails extends StatelessWidget {
  final String text;

  const YouTubeTextWithThumbnails({Key? key, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> words = text.split(' ');
    final List<Widget> widgets = [];

    for (var word in words) {
      if (word.startsWith('https://www.youtube.com/watch?v=')) {
        final videoId =
            word.substring('https://www.youtube.com/watch?v='.length);

        YoutubePlayerController controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: true,
          ),
        );
        widgets.add(
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
          ),
        );
      } else {
        widgets.add(Text(word));
      }
      widgets.add(SizedBox(width: 2)); // Add space between widgets
    }

    return Wrap(children: widgets);
  }
}
