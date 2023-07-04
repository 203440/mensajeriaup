// import 'package:mensajeriaup/features/mensajes/chat/data/datasources/chat_remote_data_source.dart';
// import 'package:mensajeriaup/features/mensajes/chat/data/repositories/chats_repository_impl.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/get_docId_usecase.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/get_messages_usecase.dart';
// import 'package:mensajeriaup/features/mensajes/chat/domain/usecases/send_message_usecase.dart';
// //import 'package:messageapp/features/message/chat/data/datasources/chat_remote_data_source.dart';
// //import 'package:messageapp/features/message/chat/data/repositories/chats_repository_impl.dart';
// //import 'package:messageapp/features/message/chat/domain/usecases/get_docId_usecase.dart';
// //import 'package:messageapp/features/message/chat/domain/usecases/get_messages_usecase.dart';
// //import 'package:messageapp/features/message/chat/domain/usecases/send_message_usecase.dart';

// class UsecaseConfigchat {
//   GetDocIdUsecase? getDocIdUsecase;
//   ChatRepositoryImpl? chatRepositoryImpl;
//   ChatsRemoteDataSourceImp? chatsRemoteDataSourceImp;
//   SendMessageUsecase? sendMessageUsecase;
//   GetMessagessUsecase? getMessagessUsecase;

//   UsecaseConfigchat() {
//     chatsRemoteDataSourceImp = ChatsRemoteDataSourceImp();
//     chatRepositoryImpl =
//         ChatRepositoryImpl(chatsRemoteDataSource: chatsRemoteDataSourceImp!);
//     getDocIdUsecase = GetDocIdUsecase(chatRepositoryImpl!);
//     sendMessageUsecase = SendMessageUsecase(chatRepositoryImpl!);
//     getMessagessUsecase = GetMessagessUsecase(chatRepositoryImpl!);
//   }
// }
