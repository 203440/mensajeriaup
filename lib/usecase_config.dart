import 'package:mensajeriaup/features/mensajes/users/data/datasources/user_remote_data.dart';
import 'package:mensajeriaup/features/mensajes/users/data/repositories/user_repository_im.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/usecases/add_user.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/usecases/get_users_usecase.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/usecases/verific_user_usecase.dart';

class UsecaseConfig {
  GetUsersUsecase? getUsersUsecase;
  CreateUserUsecase? createUserUsecase;
  ValidateUsersUsecase? validateUsersUsecase;

  UsersRepositoryImpl? usersRepositoryImpl;
  UsersRemoteDataSourceImp? usersRemoteDataSourceImp;

  UsecaseConfig() {
    usersRemoteDataSourceImp = UsersRemoteDataSourceImp();
    usersRepositoryImpl =
        UsersRepositoryImpl(usersRemoteDataSource: usersRemoteDataSourceImp!);
    getUsersUsecase = GetUsersUsecase(usersRepositoryImpl!);
    createUserUsecase = CreateUserUsecase(usersRepositoryImpl!);
    validateUsersUsecase = ValidateUsersUsecase(usersRepositoryImpl!);
  }
}
