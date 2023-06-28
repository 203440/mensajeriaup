import 'package:flutter/material.dart';
import 'package:mensajeriaup/features/mensajes/chat/data/repositories/message_repository_data.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/get_messages.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/send_message.dart';
import 'package:mensajeriaup/features/mensajes/chat/presentation/pages/home_chat.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(71, 134, 250, 1),
        title: Text(
          'Mensajes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 1, // Número de mensajes en la lista
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text('Usuario prueba'),
                  subtitle: Text('Último mensaje...'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          getMessages: GetMessages(FirebaseMessageRepository()),
                          sendMessage: SendMessage(FirebaseMessageRepository()),
                        ),
                      ),
                    );
                    // Acción al hacer clic en un chat
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción al hacer clic en el botón flotante
        },
        backgroundColor: Color.fromRGBO(71, 134, 250, 1),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
