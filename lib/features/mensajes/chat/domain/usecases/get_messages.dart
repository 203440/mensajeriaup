// lib/domain/usecases/get_messages.dart

import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/repositories/message_repository.dart';

class GetMessages {
  final MessageRepository repository;

  GetMessages(this.repository);

  Future<List<Message>> call() {
    return repository.getMessages();
  }
}
