part of 'message_bloc.dart';

@immutable
abstract class MessageState {}


















class LoadingState extends MessageState {}

class LoadedState extends MessageState {
  final List<Message> messages;

  LoadedState(this.messages);
}

class ErrorState extends MessageState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}
