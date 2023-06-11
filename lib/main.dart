import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/blocs/users_bloc.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/pages/principal.dart';
//import 'package:mensajeriaup/features/mensajes/users/presentation/pages/login.dart';
//import 'package:mensajeriaup/features/mensajes/users/presentation/pages/register.dart';
//import 'package:mensajeriaup/testfirebase.dart';
import 'package:mensajeriaup/usecase_config.dart';
//import 'features/mensajes/users/presentation/pages/sign.dart';
//import 'firebase_options.dart';

UsecaseConfig usecaseConfig = UsecaseConfig();

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
