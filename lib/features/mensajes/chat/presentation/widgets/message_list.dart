// lib/presentation/widgets/message_list.dart

import 'package:flutter/material.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:mensajeriaup/features/mensajes/chat/presentation/widgets/message_item.dart';
import 'package:video_player/video_player.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;

  MessageList({required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(137, 212, 172, 1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Wrap(
              children: [
                if (message.imageUrl?.isNotEmpty == true)
                  Image.network(
                    message.imageUrl!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                if (message.videoUrl?.isNotEmpty == true)
                  VideoPlayer(VideoPlayerController.network(message.videoUrl!)),
                Text(
                  message.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// class MessageList extends StatelessWidget {
//   final List<Message> messages;

//   MessageList({required this.messages});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: messages.length,
//       itemBuilder: (context, index) {
//         final message = messages[index];
//         return MessageItem(message: message);
//       },
//     );
//   }
// }
