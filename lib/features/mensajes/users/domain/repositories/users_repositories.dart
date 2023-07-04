import 'package:mensajeriaup/features/mensajes/users/domain/entities/user.dart';
//import 'package:messageapp/features/message/users/domain/entities/user.dart';

abstract class UsersRepository {
  Future<List<User>> getUsers(username);
  Future<String> createUser(username, correo, passw);
  Future<Map<String, dynamic>> validateUser(username, passw);
  // Future<String> updateGames(id, stars, descri, titulo, img);

  // Future<String> deleteGames(id);
}
