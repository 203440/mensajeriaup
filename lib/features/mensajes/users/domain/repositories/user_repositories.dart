import 'package:mensajeriaup/features/mensajes/users/domain/entities/user.dart';

abstract class UsersRepository {
  Future<List<User>> getUsers();
  Future<String> createUser(username, correo, passw);
  Future<String> validateUser(username, passw);
}
