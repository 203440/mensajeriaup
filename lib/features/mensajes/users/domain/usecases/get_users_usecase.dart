import 'package:mensajeriaup/features/mensajes/users/domain/entities/user.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/repositories/user_repositories.dart';

class GetUsersUsecase {
  final UsersRepository usersRepository;

  GetUsersUsecase(this.usersRepository);

  Future<List<User>> execute() async {
    return await usersRepository.getUsers();
  }
}
