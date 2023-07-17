import 'package:mensajeriaup/features/mensajes/users/domain/repositories/users_repositories.dart';

class CreateUserUsecase {
  final UsersRepository usersRepository;

  CreateUserUsecase(this.usersRepository);

  Future<String> execute(username, correo, passw) async {
    return await usersRepository.createUser(username, correo, passw);
  }
}
