import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mensajeriaup/features/mensajes/users/presentation/blocs/users_bloc.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _email;
  late String _password;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 150.0),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Nombre de usuario'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, introduce un nombre de usuario';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Correo electrónico'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, introduce un correo electrónico';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, introduce una contraseña';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
              ),
              BlocBuilder<UsersBloc, UsersState>(
                builder: (context, state) {
                  if (state is SavingUser) {
                    return const CircularProgressIndicator();
                  } else if (state is UserSaved) {
                    return const Text("Usuario guardado exitosamente",
                        style: TextStyle(color: Colors.green));
                  } else if (state is ErrorSavingUser) {
                    return Text(state.message,
                        style: const TextStyle(color: Colors.red));
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 5, 130,
                      232), // Cambia "Colors.blue" por el color que desees
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Aquí puedes realizar las acciones necesarias para registrar al usuario
                    // como enviar los datos a una API o guardarlos localmente.

                    context.read<UsersBloc>().add(PressCreateUserButton(
                        username: _username, correo: _email, passw: _password));

                    print('Nombre de usuario: $_username');
                    print('Correo electrónico: $_email');
                    print('Contraseña: $_password');
                  }
                },
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
