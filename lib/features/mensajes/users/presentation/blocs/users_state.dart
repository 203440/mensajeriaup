part of 'users_bloc.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}

class Loading extends UsersState {}

class Loaded extends UsersState {
  final List<User> users;

  Loaded({required this.users});
}

class Error extends UsersState {
  final String error;

  Error({required this.error});
}

// Crea Usuario
class SavingUser extends UsersState {}

class UserSaved extends UsersState {}

class ErrorSavingUser extends UsersState {
  final String message;

  ErrorSavingUser({required this.message});
}

// login usuario

class UserVerificando extends UsersState {}

class UserVerificado extends UsersState {
  final Map<String, dynamic> estado;

  UserVerificado({required this.estado});
}

class ErrorLoginUser extends UsersState {
  final String message;

  ErrorLoginUser({required this.message});
}
