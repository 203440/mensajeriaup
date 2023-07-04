// lib/domain/usecases/send_message.dart

import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/repositories/message_repository.dart';

class SendMessage {
  final MessageRepository repository;

  SendMessage(this.repository);

  Future<void> call(Message message) async {
    await repository.saveMessage(message);
  }
}
