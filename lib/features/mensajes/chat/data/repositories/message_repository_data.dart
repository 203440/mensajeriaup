import 'package:mensajeriaup/features/mensajes/chat/data/datasources/message_datasource.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/repositories/message_repository.dart';
import 'package:mensajeriaup/features/mensajes/chat/data/models/message_model.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageDataSource dataSource;

  MessageRepositoryImpl(this.dataSource);

  @override
  Future<void> saveMessage(Message message) async {
    final messageModel = MessageModel.fromEntity(message);
    await dataSource.saveMessage(messageModel);
  }

  @override
  Future<List<Message>> getMessages() async {
    final messageModels = await dataSource.getMessages();
    return messageModels.map((model) => model.toEntity()).toList();
  }
}

// import 'package:mensajeriaup/features/mensajes/chat/data/datasources/message_datasource.dart';

// import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/repositories/message_repository.dart';
// import '../models/message_model.dart';

// class MessageRepositoryImp implements MessageRepository {
//   final MessageDataSource dataSource;

//   MessageRepositoryImp(this.dataSource);

//   @override
//   Future<void> saveMessage(Message message) async {
//     final messageModel = MessageModel.fromEntity(message);
//     await dataSource.saveMessage(messageModel);
//   }

//   @override
//   Future<List<MessageModel>> getMessages() async {
//     return dataSource.getMessages();
//   }
// }

// lib/data/repositories/message_repository.dart

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/repositories/message_repository.dart';

// class FirebaseMessageRepository implements MessageRepository {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Future<void> sendMessage(Message message) async {
//     try {
//       final messageData = {
//         'id': message.id,
//         'text': message.text,
//         'videoUrl': message.videoUrl,
//         'audioUrl': message.audioUrl,
//         'imageUrl': message.imageUrl,
//         'gifUrl': message.gifUrl,
//       };

//       if (message.videoUrl != null) {
//         final videoUrl = await _uploadFile(message.videoUrl!, 'videos');
//         messageData['videoUrl'] = videoUrl;
//       }

//       if (message.audioUrl != null) {
//         final audioUrl = await _uploadFile(message.audioUrl!, 'audios');
//         messageData['audioUrl'] = audioUrl;
//       }

//       if (message.imageUrl != null) {
//         final imageUrl = await _uploadFile(message.imageUrl!, 'images');
//         messageData['imageUrl'] = imageUrl;
//       }

//       if (message.gifUrl != null) {
//         final gifUrl = await _uploadFile(message.gifUrl!, 'gifs');
//         messageData['gifUrl'] = gifUrl;
//       }

//       await _firestore.collection('messages').add(messageData);
//     } catch (e) {
//       // Manejo de errores
//       print('Error al enviar el mensaje: $e');
//       throw e;
//     }
//   }

//   @override
//   Future<List<Message>> getMessages() async {
//     try {
//       final querySnapshot = await _firestore.collection('messages').get();
//       final messages = querySnapshot.docs.map((doc) {
//         final data = doc.data();
//         return Message(
//           id: data['id'],
//           text: data['text'],
//           videoUrl: data['videoUrl'],
//           audioUrl: data['audioUrl'],
//           imageUrl: data['imageUrl'],
//           gifUrl: data['gifUrl'],
//         );
//       }).toList();
//       return messages;
//     } catch (e) {
//       // Manejo de errores
//       print('Error al recuperar los mensajes: $e');
//       throw e;
//     }
//   }

//   Future<String> _uploadFile(String filePath, String folder) async {
//     try {
//       final file = File(filePath);
//       final fileName = file.path.split('/').last;
//       final ref = _storage.ref().child('$folder/$fileName');
//       final uploadTask = ref.putFile(file);

//       final snapshot = await uploadTask.whenComplete(() => null);

//       if (snapshot.state == TaskState.success) {
//         final downloadUrl = await snapshot.ref.getDownloadURL();
//         return downloadUrl;
//       } else {
//         throw Exception('Error al subir el archivo');
//       }
//     } catch (e) {
//       throw Exception('Error al subir el archivo: $e');
//     }
//   }
// }


// lib/data/repositories/message_repository.dart

// import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/repositories/message_repository.dart';

// class FirebaseMessageRepository implements MessageRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Future<void> sendMessage(Message message) async {
//     try {
//       await _firestore.collection('messages').add({
//         'id': message.id,
//         'text': message.text,
//       });
//     } catch (e) {
//       // Manejo de errores
//       print('Error al enviar el mensaje: $e');
//       throw e;
//     }
//   }

//   @override
//   Future<List<Message>> getMessages() async {
//     try {
//       final querySnapshot = await _firestore.collection('messages').get();
//       final messages = querySnapshot.docs.map((doc) {
//         final data = doc.data();
//         return Message(id: data['id'], text: data['text']);
//       }).toList();
//       return messages;
//     } catch (e) {
//       // Manejo de errores
//       print('Error al recuperar los mensajes: $e');
//       throw e;
//     }
//   }
// }

//