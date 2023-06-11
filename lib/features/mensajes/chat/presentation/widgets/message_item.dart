// lib/presentation/widgets/message_item.dart

import 'package:flutter/material.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:audioplayers/audioplayers.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  MessageItem({required this.message});

  Widget _buildTextMessage() {
    return ListTile(
      title: Text(message.text),
    );
  }

  Widget _buildVideoMessage() {
    final videoPlayerController =
        VideoPlayerController.network(message.videoUrl!);
    return FutureBuilder(
      future: videoPlayerController.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: VideoPlayer(videoPlayerController),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  // Widget _buildAudioMessage() {
  //   final audioPlayer = AudioPlayer();
  //   return ListTile(
  //     title: Text('Audio'),
  //     onTap: () => audioPlayer.play(message.audioUrl!),
  //   );
  // }

  Widget _buildImageMessage() {
    return CachedNetworkImage(
      imageUrl: message.imageUrl!,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget _buildGifMessage() {
    return CachedNetworkImage(
      imageUrl: message.gifUrl!,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (message.videoUrl != null) {
      return _buildVideoMessage();
      // } else if (message.audioUrl != null) {
      //   return _buildAudioMessage();
    } else if (message.imageUrl != null) {
      return _buildImageMessage();
    } else if (message.gifUrl != null) {
      return _buildGifMessage();
    } else {
      return _buildTextMessage();
    }
  }
}



// lib/presentation/widgets/message_item.dart

// import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';

// class MessageItem extends StatelessWidget {
//   final Message message;

//   MessageItem({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(message.text),
//     );
//   }
// }
// lib/presentation/widgets/message_item.dart
