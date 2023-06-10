import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert' as convert;

import 'package:mensajeriaup/features/mensajes/users/data/models/user_models.dart';

abstract class UsersRemoteDataSource {
  Future<List<UsersModel>> getUsers();
  Future<String> createUser(username, correo, passw);
  Future<String> validateUser(username, passw);
}

class UsersRemoteDataSourceImp implements UsersRemoteDataSource {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<List<UsersModel>> getUsers() async {
    List users = [];
    CollectionReference collectionReferenceGames = db.collection('users');

    QuerySnapshot queryUsers = await collectionReferenceGames.get();

    for (var doc in queryUsers.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      final user = {
        'username': data['username'],
        'correo': data['correo'],
        'id': doc.id,
        'passw': data['passw']
      };
      users.add(user);
    }

    return users.map<UsersModel>((data) => UsersModel.fromJson(data)).toList();
  }

  @override
  Future<String> createUser(username, correo, passw) async {
    final data = {
      "username": username.toString(),
      "correo": correo.toString(),
      "passw": passw.toString(),
    };

    await db.collection("users").add(data);

    return "si";
  }

  @override
  Future<String> validateUser(username, passw) async {
    String status = "desconocido";
    CollectionReference collectionReferenceUsers = db.collection('users');

    QuerySnapshot queryGames = await collectionReferenceUsers.get();

    for (var doc in queryGames.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data['username'] == username) {
        if (data['passw'] == passw) {
          status = "correcto";
        } else {
          status = "incorrecto";
        }
      } else {
        status = "incorrecto";
      }
    }

    return status;
  }
}
