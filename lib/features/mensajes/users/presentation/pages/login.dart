import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mensajeriaup/features/mensajes/chat/presentation/pages/home_chat.dart';
import 'package:mensajeriaup/features/mensajes/chat/presentation/pages/vista.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/blocs/users_bloc.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/pages/principal.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is UserVerificando) {
                  return const CircularProgressIndicator();
                } else if (state is UserVerificado) {
                  if (state.estado == "correcto") {
                    return const Text("validado");
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error de inicio de sesión'),
                            content: const Text(
                                'Credenciales inválidas. Por favor, inténtalo de nuevo.'),
                            actions: [
                              TextButton(
                                child: const Text('Cerrar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                    return Container();
                  }
                } else if (state is ErrorLoginUser) {
                  return Text(state.message,
                      style: const TextStyle(color: Colors.red));
                } else {
                  return Container();
                }
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 5, 130,
                    232), // Cambia "Colors.blue" por el color que desees
              ),
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;

                context.read<UsersBloc>().add(
                    PressLoginUserButton(username: username, passw: password));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ),
                );
              },
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
