import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mensajeriaup/features/mensajes/users/data/models/users_models.dart';
import 'dart:convert' as convert;

//import 'package:messageapp/features/message/users/data/models/users_models.dart';

abstract class UsersRemoteDataSource {
  Future<List<UsersModel>> getUsers(username);
  Future<String> createUser(username, correo, passw);
  Future<Map<String, dynamic>> validateUser(username, passw);
  // Future<String> updateGames(id, stars, descri, titulo, img);
  // Future<String> deleteGames(id);
}

class UsersRemoteDataSourceImp implements UsersRemoteDataSource {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<List<UsersModel>> getUsers(username) async {
    List users = [];
    CollectionReference collectionReferenceGames = db.collection('users');

    // Realiza la consulta utilizando la cláusula "where"

    await collectionReferenceGames
        .where('username', isNotEqualTo: username)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Accede a los datos de cada documento
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        final user = {
          'username': data['username'],
          'correo': data['correo'],
          'id': doc.id,
          'passw': data['passw']
        };

        users.add(user);
      });
    }).catchError((error) {
      return ("Error getting documents: $error");
    });

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
  Future<Map<String, dynamic>> validateUser(username, passw) async {
    CollectionReference collectionReferenceGames = db.collection('users');

    QuerySnapshot queryGames = await collectionReferenceGames.get();
    Map<String, dynamic> estatus = {
      'estado': 'incorrecto',
    };

    for (var doc in queryGames.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data['username'] == username) {
        if (data['passw'] == passw) {
          Map<String, dynamic> resultado = {
            'username': data['username'],
            'correo': data['correo'],
            'estado': 'correcto',
          };
          return resultado;
        }
      }
    }

    return estatus;
  }
}
