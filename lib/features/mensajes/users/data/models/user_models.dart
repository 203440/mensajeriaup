import 'package:mensajeriaup/features/mensajes/users/domain/entities/user.dart';

class UsersModel extends User {
  UsersModel(
      {required String username,
      required String correo,
      required String passw,
      required String id})
      : super(username: username, correo: correo, passw: passw, id: id);

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    // print(json['Estrellas']);
    return UsersModel(
        username: json['username'],
        correo: json['correo'],
        passw: json['passw'],
        id: json['id']);
  }

  factory UsersModel.fromEntity(User user) {
    return UsersModel(
        username: user.username,
        correo: user.correo,
        passw: user.passw,
        id: user.id);
  }
}