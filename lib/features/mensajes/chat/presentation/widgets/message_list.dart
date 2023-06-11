// lib/presentation/widgets/message_list.dart

import 'package:flutter/material.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:mensajeriaup/features/mensajes/chat/presentation/widgets/message_item.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;

  MessageList({required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return MessageItem(message: message);
      },
    );
  }
}

// // lib/presentation/widgets/message_list.dart

// import 'package:flutter/material.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
// import 'package:mensajeriaup/features/mensajes/chat/presentation/widgets/message_item.dart';

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
