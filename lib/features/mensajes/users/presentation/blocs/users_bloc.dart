import 'package:bloc/bloc.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/entities/user.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/usecases/add_user.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/usecases/get_users_usecase.dart';
import 'package:mensajeriaup/features/mensajes/users/domain/usecases/verific_user_usecase.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsersUsecase getUsersUsecase;
  final CreateUserUsecase createUserUsecase;
  final ValidateUsersUsecase validateUsersUsecase;

  UsersBloc(
      {required this.getUsersUsecase,
      required this.createUserUsecase,
      required this.validateUsersUsecase})
      : super(Loading()) {
    on<UsersEvent>((event, emit) async {
      if (event is GetUsers) {
        try {
          List<User> response = await getUsersUsecase.execute();
          emit(Loaded(users: response));
        } catch (e) {
          emit(Error(error: e.toString()));
        }
      } else if (event is PressCreateUserButton) {
        try {
          emit(SavingUser());
          await createUserUsecase.execute(
              event.username, event.correo, event.passw);
          emit(UserSaved());
        } catch (e) {
          emit(ErrorSavingUser(message: e.toString()));
        }
      } else if (event is PressLoginUserButton) {
        try {
          emit(UserVerificando());
          String resultado =
              await validateUsersUsecase.execute(event.username, event.passw);
          emit(UserVerificado(estado: resultado));
        } catch (e) {
          emit(ErrorLoginUser(message: e.toString()));
        }
      }
    });
  }
}
