import 'package:mensajeriaup/features/mensajes/users/domain/entities/user.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/repositories/users_repositories.dart';
//import 'package:messageapp/features/message/users/domain/entities/user.dart';
//import 'package:messageapp/features/message/users/domain/repositories/users_repositories.dart';

class GetUsersUsecase {
  final UsersRepository usersRepository;

  GetUsersUsecase(this.usersRepository);

  Future<List<User>> execute(username) async {
    return await usersRepository.getUsers(username);
  }
}
