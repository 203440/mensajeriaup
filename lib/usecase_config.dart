import 'package:mensajeriaup/features/mensajes/chat/data/datasources/message_datasource.dart';
import 'package:mensajeriaup/features/mensajes/chat/data/repositories/message_repository_data.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/get_messages.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/send_message.dart';
import 'package:mensajeriaup/features/mensajes/users/data/datasources/user_remote_data_source.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/usecases/create_games_usecase.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/usecases/get_users_usecase.dart';
import 'features/mensajes/users/data/repositories/users_repository_impl.dart';
import 'features/mensajes/users/domain/usecases/validate_user_usecase.dart';

class UsecaseConfig {
  GetUsersUsecase? getUsersUsecase;
  CreateUserUsecase? createUserUsecase;
  ValidateUsersUsecase? validateUsersUsecase;

  UsersRepositoryImpl? usersRepositoryImpl;
  UsersRemoteDataSourceImp? usersRemoteDataSourceImp;

  GetMessages? getMessagesUseCase;
  SendMessage? saveMessageUseCase;
  MessageRepositoryImpl? messageRepositoryImp;
  FirebaseMessageDataSource firebaseMessageDataSource;

  UsecaseConfig(this.firebaseMessageDataSource) {
    messageRepositoryImp = MessageRepositoryImpl(firebaseMessageDataSource);
    getMessagesUseCase = GetMessages(messageRepositoryImp!);
    saveMessageUseCase = SendMessage(messageRepositoryImp!);

    usersRemoteDataSourceImp = UsersRemoteDataSourceImp();
    usersRepositoryImpl =
        UsersRepositoryImpl(usersRemoteDataSource: usersRemoteDataSourceImp!);
    getUsersUsecase = GetUsersUsecase(usersRepositoryImpl!);
    createUserUsecase = CreateUserUsecase(usersRepositoryImpl!);
    validateUsersUsecase = ValidateUsersUsecase(usersRepositoryImpl!);
  }
}
