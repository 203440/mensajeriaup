import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mensajeriaup/features/mensajes/chat/presentation/pages/vista.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/blocs/users_bloc.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/pages/register.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(71, 134, 250, 1),
        title: Text('Login',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 200.0),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.key),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 24.0),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    String username = _emailController.text;
                    String password = _passwordController.text;

                    context.read<UsersBloc>().add(PressLoginUserButton(
                        username: username, passw: password));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(3, 169, 244, 1),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              BlocBuilder<UsersBloc, UsersState>(
                builder: (context, state) {
                  if (state is UserVerificando) {
                    return const CircularProgressIndicator();
                  } else if (state is UserVerificado) {
                    if (state.estado['estado'] == "correcto") {
                      print("nombre del estado");
                      print(state.estado['username']);
                      //String usernames = _emailController.text;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MensajeriaScreen()),
                        );
                      });
                      return const SizedBox();
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
                    }
                    return Container();
                  } else if (state is ErrorLoginUser) {
                    return Text(state.message,
                        style: const TextStyle(color: Colors.red));
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(),
                    ),
                  );
                },
                child: Text(
                  '¿No tienes cuenta? Crear Una',
                  style: TextStyle(
                    color: Color.fromRGBO(3, 169, 244, 1).withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
