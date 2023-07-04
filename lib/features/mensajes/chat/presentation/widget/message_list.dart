import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:video_player/video_player.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.imageUrl != null) {
      print('imagen');
      print(message.imageUrl);
      // Si es una imagen
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(137, 212, 172, 1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          //child: Image.file(message.imageUrl!),
        ),
      );
    } else if (message.videoUrl != null) {
      // Si es un video
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(137, 212, 172, 1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          //child: _buildVideoPlayer(message.videoUrl!),
        ),
      );
    } else if (message.audioUrl != null) {
      // Si es un audio
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(137, 212, 172, 1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          //child: _buildAudioPlayer(message.audioUrl!),
        ),
      );
    } else if (message.gifUrl != null) {
      // Si es un GIF
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(12.0),
          ),
          //child: Image.file(message.gifUrl!),
        ),
      );
    } else {
      // Si es un mensaje de texto
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(137, 212, 172, 1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.all(8.0),
          child: Text(
            message.text ?? '',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Widget _buildVideoPlayer(File videoFile) {
    final videoController = VideoPlayerController.file(videoFile);

    return AspectRatio(
      aspectRatio: videoController.value.aspectRatio,
      child: VideoPlayer(videoController),
    );
  }

  Widget _buildAudioPlayer(File audioFile) {
    final audioPlayer = AudioPlayer();

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => audioPlayer.stop(),
          child: Text('Stop Audio'),
        ),
        ElevatedButton(
          onPressed: () => audioPlayer.pause(),
          child: Text('Pause Audio'),
        ),
      ],
    );
  }
}
