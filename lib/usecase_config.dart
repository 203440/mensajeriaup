// import 'package:mensajeriaup/features/mensajes/chat/data/repositories/message_repository_data.dart';
// import 'package:mensajeriaup/features/mensajes/users/data/datasources/user_remote_data.dart';
// import 'package:mensajeriaup/features/mensajes/users/data/repositories/user_repository_im.dart';
// import 'package:mensajeriaup/features/mensajes/users/domain/usecases/add_user.dart';
// import 'package:mensajeriaup/features/mensajes/users/domain/usecases/get_users_usecase.dart';
// import 'package:mensajeriaup/features/mensajes/users/domain/usecases/verific_user_usecase.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/send_message.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/entities/message.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class UsecaseConfig {
//   GetUsersUsecase? getUsersUsecase;
//   CreateUserUsecase? createUserUsecase;
//   ValidateUsersUsecase? validateUsersUsecase;
//   SendMessage? sendMessage;
//   //FirebaseStorage _storage = FirebaseStorage.instance;

//   UsersRepositoryImpl? usersRepositoryImpl;
//   FirebaseMessageRepository? messageRepository;
//   UsersRemoteDataSourceImp? usersRemoteDataSourceImp;

//   UsecaseConfig() {
//     usersRemoteDataSourceImp = UsersRemoteDataSourceImp();
//     usersRepositoryImpl =
//         UsersRepositoryImpl(usersRemoteDataSource: usersRemoteDataSourceImp!);
//     getUsersUsecase = GetUsersUsecase(usersRepositoryImpl!);
//     createUserUsecase = CreateUserUsecase(usersRepositoryImpl!);
//     validateUsersUsecase = ValidateUsersUsecase(usersRepositoryImpl!);
//     sendMessage = SendMessage(messageRepository!);
//   }
// }

import 'package:mensajeriaup/features/mensajes/chat/data/repositories/message_repository_data.dart';
import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/send_message.dart';
import 'package:mensajeriaup/features/mensajes/users/data/datasources/user_remote_data.dart';
import 'package:mensajeriaup/features/mensajes/users/data/repositories/user_repository_im.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/usecases/add_user.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/usecases/get_users_usecase.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/usecases/verific_user_usecase.dart';

class UsecaseConfig {
  GetUsersUsecase? getUsersUsecase;
  CreateUserUsecase? createUserUsecase;
  ValidateUsersUsecase? validateUsersUsecase;
  //SendMessage? sendMessage;

  UsersRepositoryImpl? usersRepositoryImpl;
  UsersRemoteDataSourceImp? usersRemoteDataSourceImp;
  //FirebaseMessageRepository? messageRepository;

  UsecaseConfig() {
    usersRemoteDataSourceImp = UsersRemoteDataSourceImp();
    usersRepositoryImpl =
        UsersRepositoryImpl(usersRemoteDataSource: usersRemoteDataSourceImp!);
    getUsersUsecase = GetUsersUsecase(usersRepositoryImpl!);
    createUserUsecase = CreateUserUsecase(usersRepositoryImpl!);
    validateUsersUsecase = ValidateUsersUsecase(usersRepositoryImpl!);
    //sendMessage = SendMessage(messageRepository!);
  }
}
