import 'package:flutter/material.dart';
//import 'package:mensajeriaup/features/mensajes/chat/data/repositories/message_repository_data.dart';
//import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/get_messages.dart';
//import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/send_message.dart';
import 'package:mensajeriaup/features/mensajes/chat/presentation/pages/home_chat.dart';

class MensajeriaScreen extends StatelessWidget {
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
                        builder: (context) => HomeChatScreen(),
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
// import 'package:flutter/material.dart';
// import 'package:mensajeriaup/features/mensajes/chat/data/datasources/message_datasource.dart';
// import 'package:mensajeriaup/features/mensajes/chat/data/repositories/message_repository_data.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/get_messages.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/send_message.dart';
// import 'package:mensajeriaup/features/mensajes/chat/presentation/blocs/homechatbloc.dart';
// import 'package:mensajeriaup/features/mensajes/chat/presentation/pages/home_chat.dart';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// // final firestore = FirebaseFirestore.instance;
// // final storage = FirebaseStorage.instance;
// // final auth = FirebaseAuth.instance;
// // final messageDataSource = FirebaseMessageDataSource(
// //   firestore: firestore,
// //   storage: storage,
// //   auth: auth,
// // );
// // final messageRepository = MessageRepositoryImpl(messageDataSource);
// // // Crea una instancia de MessageRepositoryImpl o de la implementación deseada
// // final saveMessageUseCase = SendMessage(messageRepository);
// // final getMessagesUseCase = GetMessages(messageRepository);
// // final HomeChatBloc homeChat =
// //     HomeChatBloc(saveMessageUseCase, getMessagesUseCase);

// class MensajeriaScreen extends StatelessWidget {
//   //final HomeChatBloc homeChatBloc;

//   //MensajeriaScreen({required this.homeChatBloc});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mensajería'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Abrir el chat
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => HomeChatScreen(),
//               ),
//             );
//           },
//           child: Text('Abrir Chat'),
//         ),
//       ),
//     );
//   }
// }
