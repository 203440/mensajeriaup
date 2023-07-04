import '../repositories/users_repositories.dart';

class ValidateUsersUsecase {
  final UsersRepository usersRepository;

  ValidateUsersUsecase(this.usersRepository);

  Future<Map<String, dynamic>> execute(username, passw) async {
    return await usersRepository.validateUser(username, passw);
  }
}
