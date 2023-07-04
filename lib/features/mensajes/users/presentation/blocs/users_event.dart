part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class GetUsers extends UsersEvent {
  final String username;
  GetUsers({required this.username});
}

class PressCreateUserButton extends UsersEvent {
  final String username;
  final String passw;
  final String correo;

  PressCreateUserButton(
      {required this.username, required this.correo, required this.passw});
}

class PressLoginUserButton extends UsersEvent {
  final String username;
  final String passw;

  PressLoginUserButton({required this.username, required this.passw});
}
