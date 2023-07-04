import 'dart:io';
import '../models/message_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:intl/intl.dart'; // Importa la clase DateTime

abstract class MessageDataSource {
  Future<void> saveMessage(MessageModel message);
  Future<List<MessageModel>> getMessages();
}

class FirebaseMessageDataSource implements MessageDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final FirebaseAuth auth;

  FirebaseMessageDataSource({
    required this.firestore,
    required this.storage,
    required this.auth,
  });

  @override
  Future<void> saveMessage(MessageModel message) async {
    final messageRef = firestore.collection('messages').doc();
    final messageWithId = message.copyWith(
      text: null,
      timestamp: null,
      imageUrl: null,
      videoUrl: null,
      audioUrl: null,
    );

    await messageRef.set(messageWithId.toJson());

    if (message.text != null && message.text!.length >= 1) {
      await messageRef
          .update({'text': message.text, 'timestamp': message.timestamp});
    }

    if (message.imageUrl != null) {
      final imageRef = storage.ref().child('images/${messageRef.id}');
      await messageRef.update({'imageUrl': message.imageUrl});
      final imageUrl = await imageRef.getDownloadURL();
      await messageRef.update({'imageUrl': imageUrl});
    }

    if (message.videoUrl != null) {
      final videoRef = storage.ref().child('videos/${messageRef.id}');
      await messageRef.update({'videoUrl': message.videoUrl});
      final videoUrl = await videoRef.getDownloadURL();
      await messageRef.update({'videoUrl': videoUrl});
    }

    if (message.audioUrl != null) {
      final audioRef = storage.ref().child('audios/${messageRef.id}');
      await messageRef.update({'audioUrl': message.audioUrl});
      final audioUrl = await audioRef.getDownloadURL();
      await messageRef.update({'audioUrl': audioUrl});
    }
  }

  @override
  Future<List<MessageModel>> getMessages() async {
    final messagesQuery =
        await firestore.collection('messages').orderBy('timestamp').get();
    final List<MessageModel> messages = [];

    for (final messageDoc in messagesQuery.docs) {
      final messageData = messageDoc.data();
      final messageModel = MessageModel(
        timestamp: messageData['timestamp'],
        text: messageData['text'],
        imageUrl: messageData['imageUrl'],
        videoUrl: messageData['videoUrl'],
        audioUrl: messageData['audioUrl'],
      );

      messages.add(messageModel);
    }

    return messages;
  }

  Future<File> _downloadFile(String url) async {
    final uuid = Uuid();
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${uuid.v4()}';
    final file = File(filePath);
    final response = await storage.refFromURL(url).writeToFile(file);
    if (response.state == TaskState.success) {
      return file;
    } else {
      throw Exception('Error downloading file');
    }
  }
}
