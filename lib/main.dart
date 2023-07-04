import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mensajeriaup/features/mensajes/chat/data/datasources/message_datasource.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/blocs/users_bloc.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/pages/principal.dart';
import 'package:mensajeriaup/usecase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final firebaseMessageDataSource = FirebaseMessageDataSource(
      firestore: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance,
      auth: FirebaseAuth.instance,
    );

//FirebaseMessageDataSource firebaseMessageDataSource = FirebaseMessageDataSource();
    UsecaseConfig usecaseConfig = UsecaseConfig(firebaseMessageDataSource);

    Firebase.initializeApp();
    return MultiBlocProvider(
      providers: [
        BlocProvider<UsersBloc>(
          create: (BuildContext context) => UsersBloc(
              getUsersUsecase: usecaseConfig.getUsersUsecase!,
              createUserUsecase: usecaseConfig.createUserUsecase!,
              validateUsersUsecase: usecaseConfig.validateUsersUsecase!),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const Principal(),
      ),
    );
  }
}
