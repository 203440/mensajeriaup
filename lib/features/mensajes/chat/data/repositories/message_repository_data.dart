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