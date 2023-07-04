import 'package:mensajeriaup/features/mensajes/users/data/datasources/user_remote_data_source.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/entities/user.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/repositories/users_repositories.dart';
//import 'package:messageapp/features/message/users/data/datasources/user_remote_data_source.dart';
//import 'package:messageapp/features/message/users/domain/entities/user.dart';
//import 'package:messageapp/features/message/users/domain/repositories/users_repositories.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource usersRemoteDataSource;

  UsersRepositoryImpl({required this.usersRemoteDataSource});

  @override
  Future<List<User>> getUsers(username) async {
    return await usersRemoteDataSource.getUsers(username);
  }

  @override
  Future<String> createUser(username, correo, passw) async {
    return await usersRemoteDataSource.createUser(username, correo, passw);
  }

  @override
  Future<Map<String, dynamic>> validateUser(username, passw) async {
    return await usersRemoteDataSource.validateUser(username, passw);
  }
}
