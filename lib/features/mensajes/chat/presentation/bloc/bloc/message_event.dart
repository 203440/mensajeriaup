part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {}


class LoadMessagesEvent extends MessageEvent {}

class SendMessageEvent extends MessageEvent {
  final Message message;

  SendMessageEvent(this.message);
}
