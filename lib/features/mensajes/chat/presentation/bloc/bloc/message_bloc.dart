import 'dart:async';

//import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:meta/meta.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _messageController = StreamController<MessageState>.broadcast();
  List<Message> _messages = [];

  Stream<MessageState> get chatStream => _messageController.stream;

  void dispatch(MessageEvent event) {
    if (event is LoadMessagesEvent) {
      _loadMessages();
    } else if (event is SendMessageEvent) {
      _sendMessage(event.message);
    }
  }

  Future<void> _loadMessages() async {
    try {
      _messageController.add(LoadingState());

      final snapshot =
          await _firestore.collection('messages').orderBy('timestamp').get();
      final messages =
          snapshot.docs.map((doc) => Message.fromSnapshot(doc)).toList();
      _messages = messages;

      _messageController.add(LoadedState(_messages));
    } catch (e) {
      _messageController.add(ErrorState('Error al cargar los mensajes :('));
    }
  }

  Future<void> _sendMessage(Message message) async {
    try {
      await _firestore.collection('messages').add(message.toMap());
      _loadMessages();
    } catch (e) {
      // Handle any error while sending the message to Firestore
    }
  }

  void dispose() {
    _messageController.close();
  }
}
