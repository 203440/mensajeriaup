import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';

abstract class MessageRepository {
  Future<void> sendMessage(Message message);
  Future<List<Message>> getMessages();
}