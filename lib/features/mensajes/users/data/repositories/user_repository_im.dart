import 'package:mensajeriaup/features/mensajes/users/data/datasources/user_remote_data.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/entities/user.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/repositories/user_repositories.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource usersRemoteDataSource;

  UsersRepositoryImpl({required this.usersRemoteDataSource});

  @override
  Future<List<User>> getUsers() async {
    return await usersRemoteDataSource.getUsers();
  }

  @override
  Future<String> createUser(username, correo, passw) async {
    return await usersRemoteDataSource.createUser(username, correo, passw);
  }

  @override
  Future<String> validateUser(username, passw) async {
    return await usersRemoteDataSource.validateUser(username, passw);
  }
}
