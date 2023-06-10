import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsuarios() async {
  List users = [];

  CollectionReference collectionReferenceGames = db.collection('users');

  QuerySnapshot queryGames = await collectionReferenceGames.get();

  queryGames.docs.forEach((element) {
    users.add(element.data());

    print(users);
  });

  return users;
}
